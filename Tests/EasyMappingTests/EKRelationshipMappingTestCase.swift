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

class EKRelationshipMappingTestCase: XCTestCase {
    
    var sut: EKRelationshipMapping!
    
    override func setUp() {
        super.setUp()
        sut = EKRelationshipMapping(forClass: EKObjectModel.self, withKeyPath: "foo", forProperty: "bar")
    }
    
    func testPerformanceExample() {
        XCTAssert(sut.objectClass == EKObjectModel.self)
        XCTAssertEqual(sut.keyPath, "foo")
        XCTAssertEqual(sut.property, "bar")
    }
    
    func testPersonMappingIncludesAnimals() {
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonWithAnimals.json")
        let person = EKMapper.object(fromExternalRepresentation: info, with: MappingProvider.personWithPetsMapping()) as? Person
        
        XCTAssertEqual(person?.pets.count, 4)
        let dog = person?.pets.first as? Dog
        let wolf = person?.pets.last as? Wolf
        
        XCTAssertEqual(dog?.family, "Macintosh")
        XCTAssertEqual(wolf?.pack, "Bronzebeard")
    }
    
    func testConditionalHasOneMapping() {
        Car.register(MappingProvider.carMapping())
        defer { Car.register(nil) }
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let mapping = MappingProvider.personMapping()
        let relationship = mapping.hasOneMappings.lastObject as? EKRelationshipMapping
        relationship?.condition = { _ in
            false
        }
        let person = EKMapper.object(fromExternalRepresentation: info, with: mapping) as? Person
        
        XCTAssertNil(person?.car)
    }
    
    func testConditionalHasManyMapping() {
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonWithAnimals.json")
        let mapping = MappingProvider.personWithPetsMapping()
        let relationship = mapping.hasManyMappings.lastObject as? EKRelationshipMapping
        relationship?.condition = { representation in
            return false
        }
        
        let person = EKMapper.object(fromExternalRepresentation: info,
                                     with: mapping) as? Person
        
        XCTAssertNil(person?.pets)
    }
    
}
