//
//  XCTestEasyMappingSupportTestCase.swift
//  EasyMappingExample
//
//  Created by Денис Тележкин on 27.04.17.
//  Copyright © 2017 EasyKit. All rights reserved.
//

import XCTest
import EasyMapping

class XCTestEasyMappingSupportTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Car.register(MappingProvider.carMapping())
        Person.register(MappingProvider.personMapping())
        Phone.register(MappingProvider.phoneMapping())
    }
    
    override func tearDown() {
        super.tearDown()
        Car.register(nil)
        Person.register(nil)
        Phone.register(nil)
    }
    
    func testSimpleMapping() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Car.json")
        
        let car = Car()
        car.carId = info["id"] as? Int ?? 0
        car.model = info["model"] as? String
        car.year = info["year"] as? String
        
        testObject(fromExternalRepresentation: info,
                   with: Car.objectMapping(),
                   expectedObject: car)
    }
    
    func testNonNestedMapping() {
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonNonNested.json")
        Person.register(MappingProvider.personNonNestedMapping())
        let person = Person()
        let car = Car()
        car.carId = info["carId"] as? Int ?? 0
        car.model = info["carModel"] as? String
        car.year = info["carYear"] as? String
        person.car = car
        person.name = info["name"] as? String
        person.email = info["email"] as? String
        person.gender = .male
        
        testObject(fromExternalRepresentation: info,
                   with: Person.objectMapping(),
                   expectedObject: person)
    }
    
    func testSimpleSerialization() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Car.json")
        let car = Car()
        car.carId = info["id"] as? Int ?? 0
        car.model = info["model"] as? String
        car.year = info["year"] as? String
        
        testSerializeObject(car,
                            with: Car.objectMapping(),
                            expectedRepresentation: info)
    }
    
    func testNonNestedSerialization() {
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonNonNested.json")
        Person.register(MappingProvider.personNonNestedMapping())
        let person = Person()
        let car = Car()
        car.carId = info["carId"] as? Int ?? 0
        car.model = info["model"] as? String
        car.year = info["year"] as? String
        person.car = car
        person.name = info["name"] as? String
        person.email = info["email"] as? String
        person.gender = .male
        
        testSerializeObject(person,
                            with: Person.objectMapping(),
                            expectedRepresentation: info)
    }
    
    func testNestedSerialization() {
        Phone.register(nil)
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let person = Person()
        let car = Car()
        car.carId = 3
        car.model = "i30"
        car.year = "2013"
        person.car = car
        person.name = info["name"] as? String
        person.email = info["email"] as? String
        person.gender = .male
        
        testSerializeObject(person, with: Person.objectMapping(), expectedRepresentation: info, skippingKeyPaths: ["phones","socialURL"])
    }
    
    func testIgnoreMissingFieldsProperty() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let withoutRelations = FixtureLoader.dictionary(fromFileNamed: "PersonWithoutRelations.json")
        
        let mapping = Person.objectMapping()
        var person = EKMapper.object(fromExternalRepresentation: info, with: mapping) as? Person
        
        XCTAssertNotNil(person?.car)
        XCTAssertNotNil(person?.phones)
        EKMapper.fillObject(person!, fromExternalRepresentation: withoutRelations, with: mapping)
        
        XCTAssertNil(person?.car)
        XCTAssertNil(person?.phones)
        
        person = EKMapper.fillObject(person!, fromExternalRepresentation: info, with: mapping) as? Person
        
        mapping.ignoreMissingFields = true
        
        XCTAssertNotNil(person?.car)
        XCTAssertNotNil(person?.phones)
        
        EKMapper.fillObject(person!, fromExternalRepresentation: withoutRelations, with: mapping)
        
        XCTAssertNotNil(person?.car)
        XCTAssertNotNil(person?.phones)
    }
    
    func testIgnoreMissingFieldsWorksForProperties() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        Person.register(MappingProvider.personMappingThatAssertsOnNilInValueBlock())
        let mapping = Person.objectMapping()
        
        let person = EKMapper.object(fromExternalRepresentation: info, with: mapping) as? Person
        
        mapping.ignoreMissingFields = true
        XCTAssertNotNil(person?.car)
        XCTAssertNotNil(person?.phones)
        
        EKMapper.fillObject(person!, fromExternalRepresentation: ["id":23,"name":"Lucas"], with: mapping)
        
        XCTAssertEqual(person?.gender, .male)
        XCTAssertEqual(person?.socialURL.absoluteString, "https://www.twitter.com/EasyMapping")
    }
    
}
