//
//  GzipTests.swift
//  GzipTests
//
//  Created by 1024jp on 2015-05-11.

/*
The MIT License (MIT)

© 2015-2017 1024jp

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

class GzipTests: XCTestCase {
    
    func testGZip() {
        
        let testSentence = "foo"
        
        let data = testSentence.data(using: .utf8)!
        let gzipped = try! data.gzipped()
        let uncompressed = try! gzipped.gunzipped()
        let uncompressedSentence = String(data: uncompressed, encoding: .utf8)
        
        XCTAssertNotEqual(gzipped, data)
        XCTAssertEqual(uncompressedSentence, testSentence)
        
        XCTAssertTrue(gzipped.isGzipped)
        XCTAssertFalse(data.isGzipped)
        XCTAssertFalse(uncompressed.isGzipped)
    }
    
    
    func testZeroLength() {
        
        let zeroLengthData = Data()
        
        XCTAssertEqual(try! zeroLengthData.gzipped(), zeroLengthData)
        XCTAssertEqual(try! zeroLengthData.gunzipped(), zeroLengthData)
        XCTAssertFalse(zeroLengthData.isGzipped)
    }
    
    
    func testWrongUngzip() {
        
        // data not compressed
        let data = "testString".data(using: .utf8)!
        
        var uncompressed: Data?
        do {
            uncompressed = try data.gunzipped()
        } catch let error as GzipError {
            switch error.kind {
            case .data:
                XCTAssertEqual(error.message, "incorrect header check")
                XCTAssertEqual(error.message, error.localizedDescription)
            default:
                XCTFail("Caught incorrect error.")
            }
        } catch _ {
            XCTFail("Caught incorrect error.")
        }
        XCTAssertNil(uncompressed)
    }
    
    
    func testCompressionLevel() {
        
        let data = String.lorem(length: 100_000).data(using: .utf8)!
        
        XCTAssertGreaterThan(try! data.gzipped(level: .bestSpeed).count,
                             try! data.gzipped(level: .bestCompression).count)
    }
    
    
    func testFileDecompression() {
        
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "test.txt", withExtension: "gz") else { return }
        let data = try! Data(contentsOf: url)
        let uncompressed = try! data.gunzipped()
        
        XCTAssertEqual(String(data: uncompressed, encoding: .utf8), "test")
    }
    
}


private extension String {
    
    /// Generate random letters string for test.
    static func lorem(length: Int) -> String {
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var string = ""
        for _ in 0..<length {
            let rand = Int(arc4random_uniform(UInt32(letters.characters.count)))
            let index = letters.index(letters.startIndex, offsetBy: rand)
            let character = letters.characters[index]
            string.append(character)
        }
        
        return string
    }
    
}
