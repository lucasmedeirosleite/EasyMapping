//
//  CarTestCase.swift
//  EasyMappingSwiftExample
//
//  Created by Denys Telezhkin on 20.07.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

import XCTest

class CarTestCase: XCTestCase {

    var car: Car!
    
    override func setUp() {
        super.setUp()
        
        let carInfo:[NSDictionary] = FixtureLoader.jsonObjectFromFileNamed(name: "Cars") as! [NSDictionary]
        let cars: [Car] = EKMapper.arrayOfObjectsFromExternalRepresentation(carInfo, withMapping: Car.objectMapping()) as! [Car]
        car = cars[0]
    }

    func testModel() {
        XCTAssert(car.model=="i30")
    }
    
    func testYear() {
        XCTAssert(car.year=="2013")
    }

}
