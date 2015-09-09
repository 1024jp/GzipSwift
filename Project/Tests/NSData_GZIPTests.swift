//
//  NSData_GZIPTests.swift
//  NSData+GZIPTests
//
//  Created by 1024jp on 2015-05-11.

/*
The MIT License (MIT)

© 2015 1024jp

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
import XCTest

class NSData_GZIPTests: XCTestCase
{
    func testGZip()
    {
        let testSentence = "foo"
        let encoding = NSUTF8StringEncoding
        
        let data = testSentence.dataUsingEncoding(encoding, allowLossyConversion: true)!
        let gzipped = try! data.gzippedData()
        let uncompressed = try! gzipped.gunzippedData()
        let uncompressedSentence = NSString(data: uncompressed, encoding: encoding) as! String
        
        XCTAssertEqual(uncompressedSentence, testSentence)
    }
    
    
    func testZeroLength()
    {
        let zeroLengthData = NSData()
        
        XCTAssertEqual(try! zeroLengthData.gzippedData(), zeroLengthData)
        XCTAssertEqual(try! zeroLengthData.gunzippedData(), zeroLengthData)
    }
    
    
    func testWrongUngzip()
    {
        // data not compressed
        let data = ("testString" as NSString).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        
        var uncompressed: NSData?
        do {
            uncompressed = try data.gunzippedData()
        } catch GzipError.Data(let message){
            XCTAssertEqual(message, "incorrect header check")
        } catch _ {
        }
        XCTAssertNil(uncompressed)
    }
}
