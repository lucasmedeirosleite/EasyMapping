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

class EKManagedObjectMappingTestCase: XCTestCase {
    
    func testMappingWithEntityName() {
        let mapping = EKObjectMapping(contextProvider: EKManagedMappingContextProvider(objectClass: Car.self))
        XCTAssertEqual((mapping.contextProvider as? EKManagedMappingContextProvider)?.entityName, "Car")
    }
    
    func testMappingForClassWithRootPath() {
        let mapping = EKObjectMapping(contextProvider: EKManagedMappingContextProvider(objectClass: Car.self), rootPath: "car")
        XCTAssertEqual((mapping.contextProvider as? EKManagedMappingContextProvider)?.entityName, "Car")
        XCTAssertEqual(mapping.rootPath, "car")
    }
    
//    func testMapKeyPathToProperty() {
//        let mapping = EKManagedObjectMapping(entityName: "Car")
//        mapping.mapKeyPath("created_at", toProperty: "createdAt")
//        
//        let property = mapping.propertyMappings["created_at"] as? EKPropertyMapping
//        
//        XCTAssertEqual(property?.keyPath, "created_at")
//        XCTAssertEqual(property?.property, "createdAt")
//    }
//    
//    func testMapKeyPathToPropertyWithValueBlock() {
//        let mapping = EKManagedObjectMapping(entityName: "ManagedCar")
//        mapping.mapKeyPath("id", toProperty: "identifier") { key, value, context in
//            return (Int(value as? String ?? "") ?? 0) + 1
//        }
//        
//        let property = mapping.propertyMappings["id"] as? EKPropertyMapping
//        
//        XCTAssertEqual(property?.keyPath, "id")
//        XCTAssertEqual(property?.property, "identifier")
//        XCTAssertEqual(property?.managedValueBlock?("id","3",Storage.shared.context) as? Int, 4)
//    }
//    
//    func testMapPropertiesFromArray() {
//        let mapping = EKManagedObjectMapping(forEntityName: "Car") {
//            $0.mapProperties(from: ["name","email"])
//        }
//        
//        let name = mapping.propertyMappings["name"] as? EKPropertyMapping
//        let email = mapping.propertyMappings["email"] as? EKPropertyMapping
//        
//        XCTAssertEqual(name?.keyPath, "name")
//        XCTAssertEqual(name?.property, "name")
//        XCTAssertEqual(email?.keyPath, "email")
//        XCTAssertEqual(email?.property, "email")
//    }
//    
//    func testMapPropertiesFromDictionary() {
//        let mapping = EKManagedObjectMapping(forEntityName: "Car") {
//            $0.mapProperties(from: ["id":"identifier","contact.email":"email"])
//        }
//        let id = mapping.propertyMappings["id"] as? EKPropertyMapping
//        let contact = mapping.propertyMappings["contact.email"] as? EKPropertyMapping
//        
//        XCTAssertEqual(id?.keyPath, "id")
//        XCTAssertEqual(id?.property, "identifier")
//        XCTAssertEqual(contact?.keyPath, "contact.email")
//        XCTAssertEqual(contact?.property, "email")
//    }
//    
//    func testMapKeyPathToPropertyWithDateFormatter() {
//        let mapping = EKManagedObjectMapping(forEntityName: "Car") {
//            $0.mapKeyPath("birthdate", toProperty: "birthday", with: DateFormatter())
//        }
//        let birthday = mapping.propertyMappings["birthdate"] as? EKPropertyMapping
//        
//        XCTAssertEqual(birthday?.keyPath, "birthdate")
//        XCTAssertEqual(birthday?.property, "birthday")
//        XCTAssertNotNil(birthday?.managedValueBlock)
//        XCTAssertNotNil(birthday?.managedReverseBlock)
//    }
//    
//    func testHasOneMappingForKeyPath() {
//        let mapping = ManagedMappingProvider.personMapping()
//        
//        XCTAssertEqual(mapping.hasOneMappings.count, 2)
//        XCTAssertEqual((mapping.hasOneMappings.firstObject as? EKRelationshipMapping)?.keyPath, "car")
//        XCTAssertEqual((mapping.hasOneMappings.lastObject as? EKRelationshipMapping)?.keyPath, "relative")
//        
//        XCTAssertEqual(mapping.hasManyMappings.count, 2)
//        XCTAssertEqual((mapping.hasManyMappings.firstObject as? EKRelationshipMapping)?.keyPath, "children")
//        XCTAssertEqual((mapping.hasManyMappings.lastObject as? EKRelationshipMapping)?.keyPath, "phones")
//    }
}
