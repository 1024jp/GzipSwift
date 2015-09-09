//
//  NSData+GZIP.swift
//
//  Version 2.0.0

/*
 The MIT License (MIT)
 
 © 2014-2015 1024jp <wolfrosch.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import Foundation
import zlib

private let CHUNK_SIZE: Int = 2 ^ 14
private let STREAM_SIZE: Int32 = Int32(sizeof(z_stream))


/**
Errors on gzipping/gunzipping based on the zlib error codes.
*/
public enum GzipError: ErrorType {
    // cf. http://www.zlib.net/manual.html
    
    /**
    The stream structure was inconsistent.
    
    - underlying zlib error: `Z_STREAM_ERROR` (-2)
    - parameter message: returned message by zlib
    */
    case Stream(message: String)
    
    /**
    The input data was corrupted (input stream not conforming to the zlib format or incorrect check value).
    
    - underlying zlib error: `Z_DATA_ERROR` (-3)
    - parameter message: returned message by zlib
    */
    case Data(message: String)
    
    /**
    There was not enough memory.
    
    - underlying zlib error: `Z_MEM_ERROR` (-4)
    - parameter message: returned message by zlib
    */
    case Memory(message: String)
    
    /**
    No progress is possible or there was not enough room in the output buffer.
    
    - underlying zlib error: `Z_BUF_ERROR` (-5)
    - parameter message: returned message by zlib
    */
    case Buffer(message: String)
    
    /**
    The zlib library version is incompatible with the version assumed by the caller.
    
    - underlying zlib error: `Z_VERSION_ERROR` (-6)
    - parameter message: returned message by zlib
    */
    case Version(message: String)
    
    /**
    An unknown error occurred.
    
    - parameter message: returned message by zlib
    - parameter code: return error by zlib
    */
    case Unknown(message: String, code: Int)
    
    
    private init(code: Int32, msg: UnsafePointer<CChar>)
    {
        let message =  String.fromCString(msg) ?? "Unknown error"
        
        switch code {
        case Z_STREAM_ERROR:
            self = .Stream(message: message)

        case Z_DATA_ERROR:
            self = .Data(message: message)
            
        case Z_MEM_ERROR:
            self = .Memory(message: message)
            
        case Z_BUF_ERROR:
            self = .Buffer(message: message)
            
        case Z_VERSION_ERROR:
            self = .Version(message: message)
            
        default:
            self = .Unknown(message: message, code: Int(code))
        }
    }
}


public extension NSData
{
    /**
    Create a new `NSData` object by compressing the reciver using zlib.
    Throws an error if compression failed.
    
    - throws: `GzipError`
    - returns: Gzip-compressed `NSData` object.
    */
    public func gzippedData() throws -> NSData
    {
        guard self.length > 0 else {
            return NSData()
        }
        
        var stream = self.createZStream()
        var status: Int32
        
        status = deflateInit2_(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, MAX_WBITS + 16, MAX_MEM_LEVEL, Z_DEFAULT_STRATEGY, ZLIB_VERSION, STREAM_SIZE)

        guard status == Z_OK else {
            // deflateInit2 returns:
            // Z_VERSION_ERROR  The zlib library version is incompatible with the version assumed by the caller.
            // Z_MEM_ERROR      There was not enough memory.
            // Z_STREAM_ERROR   A parameter is invalid.
            
            throw GzipError(code: status, msg: stream.msg)
        }
        
        let data = NSMutableData(length: CHUNK_SIZE)!
        while stream.avail_out == 0 {
            if Int(stream.total_out) >= data.length {
                data.length += CHUNK_SIZE
            }
            
            stream.next_out = UnsafeMutablePointer<Bytef>(data.mutableBytes).advancedBy(Int(stream.total_out))
            stream.avail_out = uInt(data.length) - uInt(stream.total_out)
            
            deflate(&stream, Z_FINISH)
        }
        
        deflateEnd(&stream)
        data.length = Int(stream.total_out)
        
        return NSData(data: data)
    }
    
    
    /**
    Create a new `NSData` object by decompressing the reciver using zlib.
    Throws an error if decompression failed.
    
    - throws: `GzipError`
    - returns: Gzip-decompressed `NSData` object.
    */
    public func gunzippedData() throws -> NSData
    {
        guard self.length > 0 else {
            return NSData()
        }
        
        var stream = self.createZStream()
        var status: Int32
        
        status = inflateInit2_(&stream, MAX_WBITS + 32, ZLIB_VERSION, STREAM_SIZE)
        
        guard status == Z_OK else {
            // inflateInit2 returns:
            // Z_VERSION_ERROR   The zlib library version is incompatible with the version assumed by the caller.
            // Z_MEM_ERROR       There was not enough memory.
            // Z_STREAM_ERROR    A parameters are invalid.
            
            throw GzipError(code: status, msg: stream.msg)
        }
        
        let data = NSMutableData(length: self.length * 2)!
        
        repeat {
            if Int(stream.total_out) >= data.length {
                data.length += self.length / 2;
            }
            
            stream.next_out = UnsafeMutablePointer<Bytef>(data.mutableBytes).advancedBy(Int(stream.total_out))
            stream.avail_out = uInt(data.length) - uInt(stream.total_out)
            
            status = inflate(&stream, Z_SYNC_FLUSH)
        } while status == Z_OK
        
        guard inflateEnd(&stream) == Z_OK && status == Z_STREAM_END else {
            // inflate returns:
            // Z_DATA_ERROR   The input data was corrupted (input stream not conforming to the zlib format or incorrect check value).
            // Z_STREAM_ERROR The stream structure was inconsistent (for example if next_in or next_out was NULL).
            // Z_MEM_ERROR    There was not enough memory.
            // Z_BUF_ERROR    No progress is possible or there was not enough room in the output buffer when Z_FINISH is used.
            
            throw GzipError(code: status, msg: stream.msg)
        }
        
        data.length = Int(stream.total_out)
        
        return NSData(data: data)
    }
    
    
    private func createZStream() -> z_stream
    {
        return z_stream(
            next_in: UnsafeMutablePointer<Bytef>(self.bytes),
            avail_in: uint(self.length),
            total_in: 0,
            next_out: nil,
            avail_out: 0,
            total_out: 0,
            msg: nil,
            state: nil,
            zalloc: nil,
            zfree: nil,
            opaque: nil,
            data_type: 0,
            adler: 0,
            reserved: 0
        )
    }
}
