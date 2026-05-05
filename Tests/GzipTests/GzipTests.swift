//
//  GzipTests.swift
//  GzipTests
//
//  GzipSwift
//  https://github.com/1024jp/GzipSwift
//
//  Created by 1024jp on 2015-05-11.
//
//  ---------------------------------------------------------------------------
//
//  The MIT License (MIT)
//
//  © 2015-2026 1024jp
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

import Foundation
import Testing
@testable import Gzip

struct GzipTests {
    
    @Test(arguments: 0..<10)
    func gzip(_: Int) throws {
        
        let testSentence = String.lorem(length: Int.random(in: 1..<100_000))
        
        let data = Data(testSentence.utf8)
        let gzipped = try data.gzipped()
        let uncompressed = try gzipped.gunzipped()
        let uncompressedSentence = String(data: uncompressed, encoding: .utf8)
        
        #expect(gzipped != data)
        #expect(uncompressedSentence == testSentence)
        
        #expect(gzipped.isGzipped)
        #expect(!data.isGzipped)
        #expect(!uncompressed.isGzipped)
    }
    
    
    @Test
    func zeroLength() throws {
        
        let zeroLengthData = Data()
        
        #expect(try zeroLengthData.gzipped() == zeroLengthData)
        #expect(try zeroLengthData.gunzipped() == zeroLengthData)
        #expect(!zeroLengthData.isGzipped)
    }
    
    
    @Test
    func wrongUngzip() throws {
        
        // data not compressed
        let data = Data("testString".utf8)
        
        let gzipError = try #require(#expect(throws: GzipError.self) {
            try data.gunzipped()
        })
        
        #expect(gzipError.kind == .data)
        #expect(gzipError.message == "incorrect header check")
        #expect(gzipError.message == gzipError.localizedDescription)
    }
    
    
    @Test
    func bufferErrorFallbackMessage() {
        
        // Z_BUF_ERROR == -5; verify the fallback message kicks in when zlib provides no message.
        let error = GzipError(code: -5, msg: nil)
        
        #expect(error.kind == .buffer)
        #expect(error.message == "No progress is possible; the input data may be incomplete or the output buffer may be full.")
    }
    
    
    @Test
    func compressionLevel() throws {
        
        let data = Data(String.lorem(length: 100_000).utf8)
        let bestSpeedData = try data.gzipped(level: .bestSpeed)
        let bestCompressionData = try data.gzipped(level: .bestCompression)
        
        #expect(bestSpeedData.count > bestCompressionData.count)
    }
    
    
    @Test
    func moduleQualifiedCompressionLevel() throws {
        
        let data = Data("test".utf8)
        let compressedData = try data.gzipped(level: Gzip.CompressionLevel.defaultCompression)
        
        #expect(try compressedData.gunzipped() == data)
    }
    
    
    @Test
    func fileDecompression() throws {
        
        let url = try #require(Bundle.module.url(forResource: "test.txt.gz", withExtension: nil))
        let data = try Data(contentsOf: url)
        let uncompressed = try data.gunzipped()
        
        #expect(data.isGzipped)
        #expect(String(data: uncompressed, encoding: .utf8) == "test")
    }
    
    
    @Test
    func decompressionWithNoHeaderAndTrailer() throws {
        
        let encoded = """
        7ZOxCsIwEIbf5ea0JNerqdmdFeygFYciHYK0lTZOIe9u9AXMTTpkOQ\
        h8hLv/7vNwmFfr7DyBuXho7Tisrh8fYAAlYiF1oWSr0EgyhCWRrpsa\
        OxCwm9xihxWMB/UuR9e7Z3zCfmqX/naPyAmMFHD+1C7WIKBKRykdrd\
        PRTTqqJINlZKAYkylOv006i4zZEBksY8HIyKFi5EuMf0kzroxzZowc\
        dHIPIYjvjjbRUSTKjmZHs6N/6WhVStS01VnRrGhW9BeKXsML
        """
        let data = try #require(Data(base64Encoded: encoded))
        let uncompressed = try data.gunzipped(wBits: -Gzip.maxWindowBits)
        let json = try #require(String(data: uncompressed, encoding: .utf8))
        
        #expect(json.first == "{")
        #expect(json.last == "}")
    }
    
    
    @Test
    func decompressionCompositedCompression() throws {
        
        let firstData = try Data("test".utf8).gzipped()
        let secondData = try Data("string".utf8).gzipped()
        
        let data = firstData + secondData
        
        let uncompressed = try data.gunzipped()
        
        #expect(data.isGzipped)
        #expect(String(data: uncompressed, encoding: .utf8) == "teststring")
    }
}


private extension String {
    
    /// Generates random letters string for test.
    ///
    /// - Parameter length: The number of characters to generate.
    /// - Returns: A rondom string.
    static func lorem(length: Int) -> String {
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
        let characters = (0..<length).map { _ in letters.randomElement()! }
        
        return String(characters)
    }
}
