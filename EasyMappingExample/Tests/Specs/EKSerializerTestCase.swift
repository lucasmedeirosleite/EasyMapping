//
//  EKSerializerTestCase.swift
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 09.04.17.
//  Copyright © 2017 EasyKit. All rights reserved.
//

import XCTest
import EasyMapping

extension Car {
    static var i30 : Car {
        let car = Car()
        car.model = "i30"
        car.year = "2013"
        car.createdAt = Date()
        return car
    }
}

extension Phone {
    static var one: Phone {
        let phone = Phone()
        phone.ddd = "85"
        phone.ddi = "55"
        phone.number = "1111-1111"
        return phone
    }
    
    static var two: Phone {
        let phone = Phone()
        phone.ddd = "11"
        phone.ddi = "55"
        phone.number = "2222-2222"
        return phone
    }
}

extension Person {
    static var socialPerson: Person {
        let person = antiSocialPerson
        person.socialURL = URL(string: "https://www.twitter.com/EasyMapping")
        return person
    }
    
    static var antiSocialPerson : Person {
        let person = Person()
        person.name = "Lucas"
        person.email = "lucastoc@gmail.com"
        person.gender = .male
        return person
    }
    
    static var driver : Person {
        let person = antiSocialPerson
        person.car = Car.i30
        return person
    }
    
    static var woman : Person {
        let person = Person()
        person.name = "Jane"
        person.email = "air@gmail.com"
        person.gender = .female
        return person
    }
    
    static var withDualSim: Person {
        let person = socialPerson
        person.phones = [Phone.one, Phone.two]
        return person
    }
}

extension Address {
    static var simple : Address {
        let address = Address()
        address.street = "A street"
        address.location = CLLocation(latitude: -30.12345, longitude: -3.12345)
        return address
    }
}

class EKSerializerTestCase: XCTestCase {
    
    func testSerializerSerializesProperties() {
        let car = Car.i30
        let sut = EKSerializer.serializeObject(car, with: MappingProvider.carMapping())
        
        XCTAssertEqual(sut["model"] as? String, "i30")
        XCTAssertEqual(sut["year"] as? String, "2013")
    }
    
    func testSerializerSerializesObjectWithRootPath() {
        let sut = EKSerializer.serializeObject(Car.i30, with: MappingProvider.carWithRootKeyMapping())
        XCTAssertNotNil(sut)
        
        let data = sut["data"] as? [String:Any]
        let car = data?["car"] as? [String:Any]
        
        XCTAssertEqual(car?["model"] as? String, "i30")
        XCTAssertEqual(car?["year"] as? String, "2013")
    }
    
    func testSerializerShouldSerializeNestedKeypaths() {
        let sut = EKSerializer.serializeObject(Car.i30, with: MappingProvider.carNestedAttributesMapping())
        
        XCTAssertEqual(sut["model"] as? String, "i30")
        XCTAssertEqual((sut["information"] as? [String:Any])?["year"] as? String, "2013")
    }
    
    func testSerializerSupportsDates() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let dateString = formatter.string(from: Date())
        
        let sut = EKSerializer.serializeObject(Car.i30, with: MappingProvider.carWithDateMapping())
        
        XCTAssertEqual(sut["model"] as? String, "i30")
        XCTAssertEqual(sut["created_at"] as? String, dateString)
    }
    
    func testSerializeObjectUsingEKMappingBlocks() {
        let sut = EKSerializer.serializeObject(Person.socialPerson, with: MappingProvider.personMapping())
        
        XCTAssertEqual(sut["socialURL"] as? String, "https://www.twitter.com/EasyMapping")
    }
    
    func testSerializerObjectUsingEKMappingBlocksAndNilValue() {
        let sut = EKSerializer.serializeObject(Person.antiSocialPerson, with: MappingProvider.personMapping())
        
        XCTAssertNil(sut["socialURL"])
    }
    
    func testSerializerIsAbleToSkipNilledOutFields() {
        let sut = EKSerializer.serializeObject(Person.socialPerson, with: MappingProvider.personMappingThatIgnoresSocialUrlDuringSerialization())
        
        XCTAssertNil(sut["socialURL"])
    }
    
    func testReverseMappingIsAbleToSerializeEnums() {
        let sut = EKSerializer.serializeObject(Person.antiSocialPerson, with: MappingProvider.personWithOnlyValueBlockMapping())
        
        XCTAssertEqual(sut["gender"] as? String, "male")
    }
    
    func testAllEnumCasesAreSerializable() {
        let sut = EKSerializer.serializeObject(Person.woman, with: MappingProvider.personWithOnlyValueBlockMapping())

        XCTAssertEqual(sut["gender"] as? String, "female")
    }
    
    func testReverseBlockWithCustomObject() {
        let sut = EKSerializer.serializeObject(Address.simple, with: MappingProvider.addressMapping())
        
        XCTAssertEqual(sut["location"] as? [Double] ?? [], [-30.12345,-3.12345])
    }
    
    func testHasOneRelationSerialization() {
        Car.register(MappingProvider.carMapping())
        defer { Car.register(nil) }
        let sut = EKSerializer.serializeObject(Person.driver, with: MappingProvider.personWithCarMapping())
        
        guard let car = sut["car"] as? [String:Any] else { XCTFail(); return }
        XCTAssertEqual(car["model"] as? String, "i30")
        XCTAssertEqual(car["year"] as? String, "2013")
    }
    
    func testHasOneMappingWithDifferentNaming() {
        Car.register(MappingProvider.carMapping())
        defer { Car.register(nil) }
        let mapping = EKObjectMapping(objectClass: Person.self)
        mapping.hasOne(Car.self, forKeyPath: "vehicle", forProperty: "car")
        let dictionary = FixtureLoader.json(fromFileNamed: "PersonWithDifferentNaming.json")
        let person = EKMapper.object(fromExternalRepresentation: dictionary, with: mapping) as? Person
        let sut = EKSerializer.serializeObject(person!, with: mapping)
        
        guard let car = sut["vehicle"] as? [String:Any] else { XCTFail(); return }
        XCTAssertEqual(car["model"] as? String, "i30")
    }
    
    func testHasManyRelationship() {
        Phone.register(MappingProvider.phoneMapping())
        defer { Phone.register(nil) }
        let sut = EKSerializer.serializeObject(Person.withDualSim, with: MappingProvider.personWithPhonesMapping())
        
        guard let phones = sut["phones"] as? [[String:Any]] else { XCTFail(); return }
        
        XCTAssertEqual(phones.count, 2)
        XCTAssertEqual(phones.first?["number"] as? String, "1111-1111")
        XCTAssertEqual(phones.last?["number"] as? String, "2222-2222")
    }
}
