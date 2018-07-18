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
@testable import EasyMapping

class EKPropertyHelperTestCase: XCTestCase {
    
    var sut: Native!
    
    override func setUp() {
        super.setUp()
        let json = FixtureLoader.dictionary(fromFileNamed: "Native.json")
        sut = EKMapper.object(fromExternalRepresentation: json, with: Native.objectMapping()) as? Native
    }
    
    func testNativePropertiesAreDetected() {
        let mapping = Native.objectMapping()
        let properties = mapping.propertyMappings as? [String:EKPropertyMapping] ?? [:]
        for property in properties.values {
            XCTAssert(EKPropertyHelper.propertyNameIsNativeProperty(property.property, from: sut))
        }
        
        XCTAssert(EKPropertyHelper.propertyNameIsNativeProperty("boolProperty", from: sut))
    }
    
    func testIdIdentification() {
        let object = MutableFoundationClass()
        XCTAssertFalse(EKPropertyHelper.propertyNameIsNativeProperty("idObject", from: object))
        
        let id = EKPropertyHelper.propertyRepresentation([1,2,3], for: object, withPropertyName: "idObject")
        
        XCTAssertNotNil(id)
    }
    
    func testAddSetObjectsOnNSObject() {
        let object = MutableFoundationClass()
        object.mutableSet = NSMutableSet(array: [1,2,3])
        EKPropertyHelper.addValue(Set([4,5]), on: object, forKeyPath: "mutableSet")
        
        XCTAssertEqual(object.mutableSet.count, 5)
        XCTAssertEqual(object.mutableSet.allObjects.compactMap { $0 as? Int }.sorted(by: { $0 < $1 }), [1,2,3,4,5])
    }
}

class EKPropertyHelperManagedTestCase : ManagedTestCase {
    func testRespectPropertyRepresentationForManagedType() {
        let withoutPhones = FixtureLoader.dictionary(fromFileNamed: "PersonWithoutPhones.json")
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let person = EKManagedObjectMapper.object(fromExternalRepresentation: withoutPhones,
                                                  with: ManagedMappingProvider.personMapping(),
                                                  in: Storage.shared.context) as! ManagedPerson
        let mapping = ManagedMappingProvider.personMapping()
        mapping.respectPropertyFoundationTypes = true
        EKManagedObjectMapper.fillObject(person, fromExternalRepresentation: info, with: mapping, in: Storage.shared.context)
        XCTAssertEqual(person.phones.count, 2)
    }
}
