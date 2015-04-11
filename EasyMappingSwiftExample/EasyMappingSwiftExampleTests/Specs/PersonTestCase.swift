//
//  PersonTestCase.swift
//  EasyMappingSwiftExample
//
//  Created by Denys Telezhkin on 20.07.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

import XCTest

class PersonTestCase: XCTestCase {

    var person:Person!
    
    override func setUp() {
        super.setUp()
        
        let personInfo = FixtureLoader.jsonObjectFromFileNamed(name: "Person") as! NSDictionary
        person = Person(properties: personInfo as [NSObject : AnyObject])
    }

    func testPersonValues() {
        XCTAssert(person.name=="Lucas")
        XCTAssert(person.email == "lucastoc@gmail.com")
        XCTAssert(person.phones.count == 2)
    }
}
