//
//  EKObjectMappingTestCase.swift
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 21.04.17.
//  Copyright © 2017 EasyKit. All rights reserved.
//

import XCTest
import EasyMapping

class EKObjectMappingTestCase: XCTestCase {
    
    func testMappingForClassConstructor() {
        let mapping = EKObjectMapping(objectClass: Car.self)
        
        XCTAssert(mapping.objectClass == Car.self)
    }
    
    func testMappingForClassWithRootPathConstructor() {
        let mapping = EKObjectMapping(objectClass: Car.self, withRootPath: "car")
        
        XCTAssert(mapping.objectClass == Car.self)
        XCTAssertEqual(mapping.rootPath, "car")
    }
    
    func testMappingForClassWithBlockConstructor() {
        let mapping = EKObjectMapping(for: Car.self) { _ in }
        
        XCTAssert(mapping.objectClass == Car.self)
    }
    
    func testMappingForClassWithBlockAndRootPathConstructor() {
        let mapping = EKObjectMapping(for: Car.self, withRootPath: "car", with: { _ in })
        
        XCTAssert(mapping.objectClass == Car.self)
        XCTAssertEqual(mapping.rootPath, "car")
    }
    
}

class EKObjectMappingPropertyMappingTestCase : XCTestCase {
    var mapping : EKObjectMapping!
    
    override func setUp() {
        super.setUp()
        mapping = EKObjectMapping(objectClass: Car.self)
    }
    
    func testMapKeyPathToProperty() {
        mapping.mapKeyPath("created_at", toProperty: "createdAt")

        let sut = mapping.propertyMappings["created_at"] as? EKPropertyMapping
        
        XCTAssertEqual(sut?.keyPath, "created_at")
        XCTAssertEqual(sut?.property, "createdAt")
    }
    
    func testMapPropertiesFromArray() {
        mapping.mapProperties(from: ["name","email"])
        
        let name = mapping.propertyMappings["name"] as? EKPropertyMapping
        let email = mapping.propertyMappings["email"] as? EKPropertyMapping
        
        XCTAssertEqual(name?.keyPath, "name")
        XCTAssertEqual(name?.property, "name")
        
        XCTAssertEqual(email?.keyPath, "email")
        XCTAssertEqual(email?.property, "email")
    }
    
    func testMapPropertiesFromArrayToPascalCase() {
        mapping.mapPropertiesFromArray(toPascalCase: ["name","email"])
        
        let name = mapping.propertyMappings["Name"] as? EKPropertyMapping
        let email = mapping.propertyMappings["Email"] as? EKPropertyMapping
        
        XCTAssertEqual(name?.keyPath, "Name")
        XCTAssertEqual(name?.property, "name")
        
        XCTAssertEqual(email?.keyPath, "Email")
        XCTAssertEqual(email?.property, "email")
    }
    
    func testMapPropertiesFromUnderscoreToCamelCase() {
        mapping.mapPropertiesFromUnderscore(toCamelCase: ["model","year","created_at","car_id"])
        
        let createdAt = mapping.propertyMappings["created_at"] as? EKPropertyMapping
        let carID = mapping.propertyMappings["car_id"] as? EKPropertyMapping
        let model = mapping.propertyMappings["model"] as? EKPropertyMapping
        
        XCTAssertEqual(createdAt?.keyPath, "created_at")
        XCTAssertEqual(createdAt?.property, "createdAt")
        
        XCTAssertEqual(carID?.keyPath, "car_id")
        XCTAssertEqual(carID?.property, "carId")
        
        XCTAssertEqual(model?.keyPath, "model")
        XCTAssertEqual(model?.property, "model")
    }
    
    func testMapPropertiesFromDictionary() {
        mapping.mapProperties(from: [
                "id":"identifier",
                "contact.email":"email"
            ])
        
        let id = mapping.propertyMappings["id"] as? EKPropertyMapping
        let email = mapping.propertyMappings["contact.email"] as? EKPropertyMapping
        
        XCTAssertEqual(id?.keyPath, "id")
        XCTAssertEqual(id?.property, "identifier")
        
        XCTAssertEqual(email?.keyPath, "contact.email")
        XCTAssertEqual(email?.property, "email")
    }
    
    func testMapKeyPathToPropertyWithDateFormatter() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = Date(timeIntervalSince1970: 0)
        let string = formatter.string(from: date)
        
        mapping.mapKeyPath("birthdate", toProperty: "birthdate", with: formatter)
        
        let sut = mapping.propertyMappings["birthdate"] as? EKPropertyMapping
        
        XCTAssertEqual(sut?.keyPath, "birthdate")
        XCTAssertEqual(sut?.property, "birthdate")
        
        XCTAssertEqual(sut?.valueBlock?("birthdate", string) as? Date, date)
        XCTAssertNil(sut?.valueBlock?("birthdate", nil))
        XCTAssertNil(sut?.valueBlock?("birthdate", 5))
        
        XCTAssertEqual(sut?.reverseBlock?(date) as? String, "01 Jan 1970")
        XCTAssertNil(sut?.reverseBlock?(nil))
        XCTAssertNil(sut?.reverseBlock?(5))
    }
    
    func testMapKeyPathToPropertyWithValueBlock() {
        let genders = ["male": Gender.male, "female":Gender.female]
        mapping.mapKeyPath("gender", toProperty: "gender") { key, value  in
            return genders[value as? String ?? ""]
        }
        
        let sut = mapping.propertyMappings["gender"] as? EKPropertyMapping
        
        XCTAssert(sut?.valueBlock?("gender","male") as? Gender == Gender.male)
    }
    
    func testMapKeypathToPropertyWithValueBlockReverseBlock() {
        let genders = ["male": Gender.male, "female":Gender.female]
        mapping.mapKeyPath("gender", toProperty: "gender", withValueBlock: { _, value in
            return genders[value as? String ?? ""]
        }, reverse: { gender in
            return genders.filter({ key,value in
                value == gender as? Gender
            }).map { $0.0 }.first
        })
        
        let sut = mapping.propertyMappings["gender"] as? EKPropertyMapping
        
        XCTAssert(sut?.valueBlock?("gender","male") as? Gender == Gender.male)
        XCTAssertEqual(sut?.reverseBlock?(Gender.male) as? String, "male")
        XCTAssertEqual(sut?.reverseBlock?(Gender.female) as? String, "female")
    }
    
    func testMapPropertiesFromMappingObject() {
        let ufo = EKObjectMapping(objectClass: ColoredUFO.self)
        ufo.mapProperties(fromMappingObject: UFO.objectMapping())
        
        let shape = ufo.propertyMappings["shape"] as? EKPropertyMapping
        let captain = ufo.hasOneMappings.firstObject as? EKRelationshipMapping
        let crew = ufo.hasManyMappings.firstObject as? EKRelationshipMapping
        
        XCTAssertEqual(shape?.keyPath, "shape")
        XCTAssertEqual(shape?.property, "shape")
        
        XCTAssertEqual(captain?.keyPath, "captain")
        XCTAssertEqual(captain?.property, "captain")
        
        XCTAssertEqual(crew?.keyPath, "crew")
        XCTAssertEqual(crew?.property, "crew")
    }
}

class EKObjectMappingRelationshipsMappingTestCase : XCTestCase {
    var sut : EKObjectMapping!
    
    override func setUp() {
        super.setUp()
        sut = MappingProvider.personMapping()
    }
    
    func testHasOneMappingForKey() {
        XCTAssertEqual(sut.hasOneMappings.count, 1)
        
        let car = sut.hasOneMappings.firstObject as? EKRelationshipMapping
        
        XCTAssertEqual(car?.keyPath, "car")
        XCTAssertEqual(car?.property, "car")
    }
    
    func testHasOneMappingForKeypathForProperty() {
        sut.hasOneMappings.removeAllObjects()
        
        sut.hasOne(Car.self, forKeyPath: "car", forProperty:"personCar")
        
        let car = sut.hasOneMappings.firstObject as? EKRelationshipMapping
        
        XCTAssertEqual(car?.keyPath, "car")
        XCTAssertEqual(car?.property, "personCar")
    }
    
    func testHasManyMappingForKeypathForProperty() {
        sut.hasManyMappings.removeAllObjects()
        
        sut.hasMany(Phone.self, forKeyPath: "phones", forProperty:"personPhones")
        
        let car = sut.hasManyMappings.firstObject as? EKRelationshipMapping
        
        XCTAssertEqual(car?.keyPath, "phones")
        XCTAssertEqual(car?.property, "personPhones")
    }
    
    func testHasManyMappingForKey() {
        XCTAssertEqual(sut.hasManyMappings.count, 1)
        let phones = sut.hasManyMappings.firstObject as? EKRelationshipMapping
        
        XCTAssertEqual(phones?.keyPath, "phones")
        XCTAssertEqual(phones?.property, "phones")
    }
}

class EKObjectMappingCustomRElationshipsMappingTestCase : XCTestCase {
    var person : EKObjectMapping!
    var phone : EKObjectMapping!
    
    override func setUp() {
        super.setUp()
        person = EKObjectMapping(objectClass: Person.self)
        phone = Phone.objectMapping()
    }
    
    func testHasOneCarMappingWithPhoneSubstitution() {
        person.hasOne(Car.self, forKeyPath: "phone", forProperty: "car", with: phone)
        
        let sut = person.hasOneMappings.firstObject as? EKRelationshipMapping
        
        XCTAssert(sut?.mapping(for: sut as Any) === phone)
        XCTAssertEqual(sut?.keyPath, "phone")
        XCTAssertEqual(sut?.property, "car")
    }
    
    func testHasManyPhoneMappingWithCarSubstitution() {
        person.hasMany(Car.self, forKeyPath: "phone", forProperty: "car", with: phone)
        
        let sut = person.hasManyMappings.firstObject as? EKRelationshipMapping
        
        XCTAssert(sut?.mapping(for: sut as Any) === phone)
        XCTAssertEqual(sut?.keyPath, "phone")
        XCTAssertEqual(sut?.property, "car")
    }
}
