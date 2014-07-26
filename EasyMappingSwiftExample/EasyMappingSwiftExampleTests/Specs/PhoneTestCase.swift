//
//  PhoneTestCase.swift
//  EasyMappingSwiftExample
//
//  Created by Denys Telezhkin on 25.07.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

import XCTest

class PhoneTestCase: XCTestCase {

    var phone:Phone!
    
    override func setUp() {
        super.setUp()
        
        let personInfo = FixtureLoader.jsonObjectFromFileNamed(name: "Person") as NSDictionary
        let person = EKMapper.objectFromExternalRepresentation(personInfo, withMapping: Person.objectMapping()) as Person
        phone = person.phones[0]
    }
    
    func testPhoneValues() {
        XCTAssert(phone.DDD == "85")
        XCTAssert(phone.DDI == "55")
        XCTAssert(phone.number == "1111-1111")
    }
}
