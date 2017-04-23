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
        car.carId = 3
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
    
    func testNativePropertiesSerialization() {
        let dictionary = FixtureLoader.json(fromFileNamed: "Native.json")
        let native = EKMapper.object(fromExternalRepresentation: dictionary, with: Native.objectMapping()) as! Native
        let sut = EKSerializer.serializeObject(native, with: Native.objectMapping())
        
        XCTAssertEqual(sut["charProperty"] as? Int, 99)
        XCTAssertEqual(sut["unsignedCharProperty"] as? Int, 117)
        
        XCTAssertEqual(sut["shortProperty"] as? Int, 1)
        XCTAssertEqual(sut["unsignedShortProperty"] as? Int, 2)
        XCTAssertEqual(sut["intProperty"] as? Int, 3)
        XCTAssertEqual(sut["unsignedIntProperty"] as? Int, 4)
        XCTAssertEqual(sut["integerProperty"] as? Int, 5)
        XCTAssertEqual(sut["unsignedIntegerProperty"] as? Int, 6)
        XCTAssertEqual(sut["longProperty"] as? Int, 7)
        XCTAssertEqual(sut["unsignedLongProperty"] as? Int, 8)
        XCTAssertEqual(sut["longLongProperty"] as? Int, 9)
        XCTAssertEqual(sut["unsignedLongLongProperty"] as? Int, 10)
        
        XCTAssertEqual(sut["floatProperty"] as? Float, 11.1)
        XCTAssertEqual(sut["cgFloatProperty"] as? CGFloat, 12.2)
        XCTAssertEqual(sut["doubleProperty"] as? Double, 13.3)
        
        XCTAssertEqual(sut["boolProperty"] as? Bool, true)
        XCTAssertEqual(sut["smallBoolProperty"] as? Bool, true)
    }
    
    func testNativePropertiesSerializationInSubclasses() {
        let dictionary = FixtureLoader.json(fromFileNamed: "NativeChild.json")
        let native = EKMapper.object(fromExternalRepresentation: dictionary, with: NativeChild.objectMapping()) as! Native
        let sut = EKSerializer.serializeObject(native, with: NativeChild.objectMapping())
        
        XCTAssertEqual(sut["intProperty"] as? Int, 777)
        XCTAssertEqual(sut["boolProperty"] as? Bool, true)
        XCTAssertEqual(sut["childProperty"] as? String, "Hello")
    }
}

class EKSerializerRelationshipsTestCase: XCTestCase {
    var mapping : EKObjectMapping!
    
    override func setUp() {
        super.setUp()
        mapping = EKObjectMapping(objectClass: Person.self)
        Phone.register(MappingProvider.phoneMapping())
        Car.register(MappingProvider.carMapping())
    }
    
    override func tearDown() {
        super.tearDown()
        Phone.register(nil)
        Car.register(nil)
    }
    
    func testHasOneMappingWithDifferentNaming() {
        mapping.hasOne(Car.self, forKeyPath: "vehicle", forProperty: "car")
        
        let sut = EKSerializer.serializeObject(Person.driver, with: mapping)
        
        guard let car = sut["vehicle"] as? [String:Any] else { XCTFail(); return }
        XCTAssertEqual(car["model"] as? String, "i30")
    }
    
    func testHasOneRelationSerialization() {
        let sut = EKSerializer.serializeObject(Person.driver, with: MappingProvider.personWithCarMapping())
        
        guard let car = sut["car"] as? [String:Any] else { XCTFail(); return }
        XCTAssertEqual(car["model"] as? String, "i30")
        XCTAssertEqual(car["year"] as? String, "2013")
    }
    
    func testHasManyRelationship() {
        let sut = EKSerializer.serializeObject(Person.withDualSim, with: MappingProvider.personWithPhonesMapping())
        
        guard let phones = sut["phones"] as? [[String:Any]] else { XCTFail(); return }
        
        XCTAssertEqual(phones.count, 2)
        XCTAssertEqual(phones.first?["number"] as? String, "1111-1111")
        XCTAssertEqual(phones.last?["number"] as? String, "2222-2222")
    }
    
    func testHasManyWithDifferentNaming() {
        mapping.hasMany(Phone.self, forKeyPath: "cellphones", forProperty: "phones")
        
        let sut = EKSerializer.serializeObject(Person.withDualSim, with: mapping)
        guard let phones = sut["cellphones"] as? [[String:Any]] else { XCTFail(); return }
        
        XCTAssertEqual(phones.count, 2)
        XCTAssertEqual(phones.last?["ddd"] as? String, "11")
        XCTAssertEqual(phones.last?["number"] as? String, "2222-2222")
    }
    
    func testHasOneRelationWithNullObject() {
        let sut = EKSerializer.serializeObject(Person.withDualSim, with: MappingProvider.personMapping())
        
        XCTAssertNil(sut["car"])
        XCTAssertEqual((sut["phones"] as? [[String:Any]])?.count, 2)
    }
    
    func testHasManyRelationWithNullObject() {
        let sut = EKSerializer.serializeObject(Person.driver, with: MappingProvider.personMapping())
        
        XCTAssertNil(sut["phones"])
        XCTAssertNotNil(sut["car"])
    }
    
    func testSerializationOfNonNestedObjects() {
        let sut = EKSerializer.serializeObject(Person.driver, with: MappingProvider.personNonNestedMapping())
        
        XCTAssertEqual(sut["carId"] as? Int, 3)
        XCTAssertEqual(sut["carModel"] as? String, "i30")
        XCTAssertEqual(sut["carYear"] as? String, "2013")
        
        XCTAssertEqual(sut["name"] as? String, "Lucas")
        XCTAssertEqual(sut["email"] as? String, "lucastoc@gmail.com")
        XCTAssertEqual(sut["gender"] as? String, "male")
    }
}
