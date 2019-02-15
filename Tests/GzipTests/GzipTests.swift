//
//  GzipTests.swift
//  GzipTests
//
//  Created by 1024jp on 2015-05-11.

/*
 The MIT License (MIT)
 
 © 2015-2019 1024jp
 
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

import XCTest
import Gzip

final class GzipTests: XCTestCase {
    
    static let allTests = [
        ("testGzip", GzipTests.testGZip),
        ("testZeroLength", GzipTests.testZeroLength),
        ("testWrongUngzip", GzipTests.testWrongUngzip),
        ("testCompressionLevel", GzipTests.testCompressionLevel),
        ("testFileDecompression", GzipTests.testFileDecompression),
        ]
    
    
    func testGZip() throws {
        
        let testSentence = "foo"
        
        let data = testSentence.data(using: .utf8)!
        let gzipped = try data.gzipped()
        let uncompressed = try gzipped.gunzipped()
        let uncompressedSentence = String(data: uncompressed, encoding: .utf8)
        
        XCTAssertNotEqual(gzipped, data)
        XCTAssertEqual(uncompressedSentence, testSentence)
        
        XCTAssertTrue(gzipped.isGzipped)
        XCTAssertFalse(data.isGzipped)
        XCTAssertFalse(uncompressed.isGzipped)
    }
    
    
    func testZeroLength() throws {
        
        let zeroLengthData = Data()
        
        XCTAssertEqual(try zeroLengthData.gzipped(), zeroLengthData)
        XCTAssertEqual(try zeroLengthData.gunzipped(), zeroLengthData)
        XCTAssertFalse(zeroLengthData.isGzipped)
    }
    
    
    func testWrongUngzip() {
        
        // data not compressed
        let data = "testString".data(using: .utf8)!
        
        var uncompressed: Data?
        do {
            uncompressed = try data.gunzipped()
            
        } catch let error as GzipError where error.kind == .data {
            XCTAssertEqual(error.message, "incorrect header check")
            XCTAssertEqual(error.message, error.localizedDescription)
            
        } catch _ {
            XCTFail("Caught incorrect error.")
        }
        
        XCTAssertNil(uncompressed)
    }
    
    
    func testCompressionLevel() throws {
        
        let data = String.lorem(length: 100_000).data(using: .utf8)!
        
        XCTAssertGreaterThan(try data.gzipped(level: .bestSpeed).count,
                             try data.gzipped(level: .bestCompression).count)
    }
    
    
    func testFileDecompression() throws {
        
        let url = self.bundleFile(name: "test.txt.gz")
        let data = try Data(contentsOf: url)
        let uncompressed = try data.gunzipped()
        
        XCTAssertEqual(String(data: uncompressed, encoding: .utf8), "test")
    }
    
    
    /// Create URL for bundled test file considering platform.
    private func bundleFile(name: String) -> URL {
        
        #if SWIFT_PACKAGE
            return URL(fileURLWithPath: "./Tests/" + name)
        #else
            return Bundle(for: type(of: self)).url(forResource: name, withExtension: nil)!
        #endif
    }
}



private extension String {
    
    /// Generate random letters string for test.
    static func lorem(length: Int) -> String {
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        return (0..<length).reduce(into: "") { (string, _) in
            string.append(letters.randomElement()!)
        }
    }
    
}
