//
//  CompressionLevel.swift
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

/// Compression level whose rawValue is based on the zlib's constants.
public struct CompressionLevel: RawRepresentable, Hashable, Sendable {
    
    /// Compression level in the range of `0` (no compression) to `9` (maximum compression).
    public var rawValue: Int32
    
    public static let noCompression = Self(Z_NO_COMPRESSION)
    public static let bestSpeed = Self(Z_BEST_SPEED)
    public static let bestCompression = Self(Z_BEST_COMPRESSION)
    
    /// The compression level chosen automatically by zlib.
    ///
    /// - Note: Although its raw value (`-1`) compares smaller than the other levels,
    ///   this case represents an automatic selection rather than minimum compression.
    public static let defaultCompression = Self(Z_DEFAULT_COMPRESSION)
    
    
    /// Creates a compression level from a raw value.
    ///
    /// - Parameter rawValue: The compression level value passed to zlib.
    public init(rawValue: Int32) {
        
        self.rawValue = rawValue
    }
    
    
    /// Creates a compression level from a raw value.
    ///
    /// - Parameter rawValue: The compression level value passed to zlib.
    public init(_ rawValue: Int32) {
        
        self.rawValue = rawValue
    }
}


extension CompressionLevel: Comparable {
    
    /// Returns a Boolean value that indicates whether the left-hand level is lower than the right-hand level.
    ///
    /// - Parameters:
    ///   - lhs: A compression level.
    ///   - rhs: Another compression level.
    /// - Returns: `true` if the raw value of `lhs` is less than the raw value of `rhs`.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        
        lhs.rawValue < rhs.rawValue
    }
}
