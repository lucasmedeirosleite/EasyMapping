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
    static var simple : Car {
        let car = Car()
        car.model = "i30"
        car.year = "2013"
        return car
    }
}

class EKSerializerTestCase: XCTestCase {
    
    func testSerializerSerializesProperties() {
        let car = Car.simple
        let sut = EKSerializer.serializeObject(car, with: MappingProvider.carMapping())
        
        XCTAssertEqual(sut["model"] as? String, "i30")
        XCTAssertEqual(sut["year"] as? String, "2013")
    }
    
    func testSerializerSerializesObjectWithRootPath() {
        let sut = EKSerializer.serializeObject(Car.simple, with: MappingProvider.carWithRootKeyMapping())
        XCTAssertNotNil(sut)
        
        let data = sut["data"] as? [String:Any]
        let car = data?["car"] as? [String:Any]
        
        XCTAssertEqual(car?["model"] as? String, "i30")
        XCTAssertEqual(car?["year"] as? String, "2013")
    }
    
    func testSerializerShouldSerializeNestedKeypaths() {
        let sut = EKSerializer.serializeObject(Car.simple, with: MappingProvider.carNestedAttributesMapping())
        
        XCTAssertEqual(sut["model"] as? String, "i30")
        XCTAssertEqual((sut["information"] as? [String:Any])?["year"] as? String, "2013")
    }
    
}
