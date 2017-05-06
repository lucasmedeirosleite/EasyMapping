//
//  EKObjectModelTestCase.swift
//  EasyMapping
//
//  Created by Денис Тележкин on 06.05.17.
//  Copyright © 2017 EasyMapping. All rights reserved.
//

import XCTest

fileprivate final class TestObjectModel: EKObjectModel {
    var foo: String!
    
    override static func objectMapping() -> EKObjectMapping {
        let mapping = super.objectMapping()
        mapping.mapKeyPath("bar", toProperty: "foo")
        return mapping
    }
}

class EKObjectModelTestCase: XCTestCase {
    
    func testObjectClass() {
        let mapping = TestObjectModel.objectMapping()
        
        XCTAssert(mapping.objectClass == TestObjectModel.self)
    }
    
    func testObjectWithProperties() {
        let object = TestObjectModel.object(withProperties: ["bar":"123"])
        
        XCTAssertEqual(object.foo, "123")
    }
    
    func testInitWithProperties() {
        let object = TestObjectModel(properties: ["bar":"123"])
        
        XCTAssertEqual(object.foo, "123")
    }
    
    func testSerializedObject() {
        let object = TestObjectModel(properties: ["bar":"123"])
        let serialized = object.serializedObject()
        
        XCTAssertEqual(serialized["bar"] as? String, "123")
    }
    
}
