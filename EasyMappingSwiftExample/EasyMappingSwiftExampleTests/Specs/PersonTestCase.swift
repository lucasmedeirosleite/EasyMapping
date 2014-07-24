//
//  PersonTestCase.swift
//  EasyMappingSwiftExample
//
//  Created by Denys Telezhkin on 20.07.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

import UIKit
import XCTest

class PersonTestCase: XCTestCase {

    var person:Person!
    
    override func setUp() {
        super.setUp()
        
        let personInfo = FixtureLoader.jsonObjectFromFileNamed(name: "Person") as NSDictionary
        person = EKMapper.objectFromExternalRepresentation(personInfo, withMapping: Person.objectMapping()) as Person
    }

    func testPersonValues() {
        XCTAssert(person.name?=="Lucas")
        XCTAssert(person.email? == "lucastoc@gmail.com")
        XCTAssert(person.car? is Car)
        if person.phones {
            XCTAssert(person.phones.count == 2)
        }
    }
}
