//
//  Car.swift
//  EasyMappingSwiftExample
//
//  Created by Denys Telezhkin on 20.07.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

class Car: EKObjectModel {
    var model : String!
    var year : String!
    var createdAt : NSDate!
}

extension Car {
    override class func objectMapping() -> EKObjectMapping{
        var mapping = EKObjectMapping(objectClass: self)
        mapping.mapPropertiesFromArray(["model","year"])
        return mapping
    }
}
