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
        let context = EKMappingContext(keyPath: "foo", value: string)
        let url = EKMappingBlocks.urlMappingBlock()(context) as? URL
    
        XCTAssertEqual(url?.absoluteString, string)
    }
    
    func testShouldReturnNilOnNonStringValue() {
        let context = EKMappingContext(keyPath: "foo", value: 6)
        let nilURL = EKMappingBlocks.urlMappingBlock()(context)
        
        XCTAssertNil(nilURL)
    }
    
    func testShouldReverseConvertURLToString() {
        let url = URL(string: "http://www.google.com")
        let context = EKMappingContext(keyPath: "url", value: url as Any)
        let string = EKMappingBlocks.urlReverseMappingBlock()(context) as? String
    
        XCTAssertEqual(string, url?.absoluteString)
    }
    
    func testURLStringShouldBeNilIfURLIsNil() {
        let url : URL? = nil
        let context = EKMappingContext(keyPath: "url", value: url as Any)
        let string = EKMappingBlocks.urlReverseMappingBlock()(context)
        
        XCTAssertNil(string)
    }
    
    func testCoreDataReverseMappingBlocks() {
        ManagedCar.register(ManagedMappingProvider.carMapping())
        ManagedPhone.register(ManagedMappingProvider.phoneMapping())
        defer {
            ManagedCar.register(nil)
            ManagedPhone.register(nil)
        }
        
//        let context = Storage.shared.context
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let mapping = ManagedMappingProvider.personWithReverseBlocksMapping()
        
        let store = EKManagedObjectStore(context: Storage.shared.context)
        let mapper = EKMapper(mappingStore: store)
        let serializer = EKSerializer(mappingStore: store)
        let person = mapper.object(fromExternalRepresentation: info,
                                                  with: mapping) as! ManagedPerson
        let sut = serializer.serializeObject(person, with: mapping)
        
        
        XCTAssertEqual(person.gender, "husband")
        XCTAssertEqual(sut["gender"] as? String, "male")
    }
    
}
