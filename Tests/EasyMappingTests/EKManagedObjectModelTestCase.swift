//
//  EKManagedObjectModelTestCase.swift
//  EasyMapping
//
//  Created by Денис Тележкин on 06.05.17.
//  Copyright © 2017 EasyMapping. All rights reserved.
//

import XCTest

fileprivate class TestManagedObjectModel : EKManagedObjectModel {
    @NSManaged var foo: String
    
    override static func objectMapping() -> EKObjectMapping {
        let mapping = super.objectMapping()
        mapping.mapKeyPath("bar", toProperty: "foo")
        return mapping
    }
}

class EKManagedObjectModelTestCase: XCTestCase {
    
    func testObjectMapping() {
        let mapping = TestManagedObjectModel.objectMapping()
        
        XCTAssert((mapping.contextProvider as? EKManagedMappingContextProvider)?.entityName.contains("TestManagedObjectModel") ?? false)
    }
}
