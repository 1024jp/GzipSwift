//
//  NSData+GZIP.swift
//
//  Version 1.0.0

/*
 The MIT License (MIT)
 
 © 2014 1024jp <wolfrosch.com>
 
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

private let CHUNK_SIZE : Int = 2 ^ 14
private let STREAM_SIZE : Int32 = Int32(sizeof(z_stream))


extension NSData
{
    /// Return gzip-compressed data object or nil.
    public func gzippedData() -> NSData?
    {
        if self.length > 0 {
            var stream = self.createZStream()
            
            if deflateInit2_(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY, ZLIB_VERSION, STREAM_SIZE) != Z_OK {
                return nil
            }
            
            var data = NSMutableData(length: CHUNK_SIZE)!
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
            
            return data
        }
    
        return nil
    }
    
    
    /// Return gzip-decompressed data object or nil.
    public func gunzippedData() -> NSData?
    {
        if self.length > 0 {
            var stream = self.createZStream()
            
            if inflateInit2_(&stream, 47, ZLIB_VERSION, STREAM_SIZE) != Z_OK {
                return nil
            }
            
            var data = NSMutableData(length: self.length * 2)!
            var status : Int32
            do {
                if Int(stream.total_out) >= data.length {
                    data.length += self.length / 2;
                }
                
                stream.next_out = UnsafeMutablePointer<Bytef>(data.mutableBytes).advancedBy(Int(stream.total_out))
                stream.avail_out = uInt(data.length) - uInt(stream.total_out)
                
                status = inflate(&stream, Z_SYNC_FLUSH)
            } while status == Z_OK
            
            if inflateEnd(&stream) == Z_OK {
                if status == Z_STREAM_END {
                    data.length = Int(stream.total_out)
                    return data
                }
            }
        }
        
        return nil
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
