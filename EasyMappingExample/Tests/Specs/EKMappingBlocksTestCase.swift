//
//  EasyMapping
//
//  Copyright (c) 2012-2017 Lucas Medeiros.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import XCTest
import EasyMapping

class EKMappingBlocksTestCase: XCTestCase {
    
    func testBlockShouldConvertFromStringToURL() {
        let string = "http://www.google.com"
        let url = EKMappingBlocks.urlMappingBlock()("foo", string) as? URL
    
        XCTAssertEqual(url?.absoluteString, string)
    }
    
    func testShouldReturnNilOnNonStringValue() {
        let number = 6
        let nilURL = EKMappingBlocks.urlMappingBlock()("foo", number)
        
        XCTAssertNil(nilURL)
    }
    
    func testShouldReverseConvertURLToString() {
        let url = URL(string: "http://www.google.com")
        let string = EKMappingBlocks.urlReverseMappingBlock()(url) as? String
    
        XCTAssertEqual(string, url?.absoluteString)
    }
    
    func testURLStringShouldBeNilIfURLIsNil() {
        let url : URL? = nil
        let string = EKMappingBlocks.urlReverseMappingBlock()(url)
        
        XCTAssertNil(string)
    }
    
}
