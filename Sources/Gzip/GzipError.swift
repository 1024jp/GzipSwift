//
//  GzipError.swift
//
//  GzipSwift
//  https://github.com/1024jp/GzipSwift
//
//  ---------------------------------------------------------------------------
//
//  The MIT License (MIT)
//
//  © 2014-2026 1024jp
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#if os(Linux)
import zlibLinux
#else
import zlib
#endif

/// Errors on gzipping/gunzipping based on the zlib error codes.
public struct GzipError: Swift.Error, Hashable, Sendable {
    // cf. http://www.zlib.net/manual.html
    
    public enum Kind: Hashable, Sendable {
        /// The stream structure was inconsistent.
        ///
        /// - underlying zlib error: `Z_STREAM_ERROR` (-2)
        case stream
        
        /// The input data was corrupted.
        /// (input stream not conforming to the zlib format or incorrect check value).
        ///
        /// - underlying zlib error: `Z_DATA_ERROR` (-3)
        case data
        
        /// There was not enough memory.
        ///
        /// - underlying zlib error: `Z_MEM_ERROR` (-4)
        case memory
        
        /// No progress is possible or there was not enough room in the output buffer.
        ///
        /// - underlying zlib error: `Z_BUF_ERROR` (-5)
        case buffer
        
        /// The zlib library version is incompatible with the version assumed by the caller.
        ///
        /// - underlying zlib error: `Z_VERSION_ERROR` (-6)
        case version
        
        /// An unknown error occurred.
        ///
        /// - parameter code: return error by zlib
        case unknown(code: Int)
    }
    
    /// The error kind.
    public var kind: Kind
    
    /// The returned message by zlib.
    public var message: String
    
    
    /// A localized message describing what error occurred.
    public var localizedDescription: String {
        
        self.message
    }
}


extension GzipError {
    
    /// Creates an error from a zlib error code and message.
    ///
    /// - Parameters:
    ///   - code: The error code returned by zlib.
    ///   - msg: The error message returned by zlib.
    init(code: Int32, msg: UnsafePointer<CChar>?) {
        
        self.kind = Kind(code: code)
        self.message = msg.flatMap(String.init(validatingCString:)) ?? self.kind.fallbackMessage
    }
}


private extension GzipError.Kind {
    
    /// Creates an error kind from a zlib error code.
    ///
    /// - Parameter code: The error code returned by zlib.
    init(code: Int32) {
        
        self = switch code {
            case Z_STREAM_ERROR: .stream
            case Z_DATA_ERROR: .data
            case Z_MEM_ERROR: .memory
            case Z_BUF_ERROR: .buffer
            case Z_VERSION_ERROR: .version
            default: .unknown(code: Int(code))
        }
    }
    
    
    /// The fallback error message for the receiver.
    var fallbackMessage: String {
        
        switch self {
            case .buffer:
                "No progress is possible; the input data may be incomplete or the output buffer may be full."
            default:
                "Unknown gzip error"
        }
    }
}
