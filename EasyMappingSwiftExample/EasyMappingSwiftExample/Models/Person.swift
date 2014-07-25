//
//  Person.swift
//  EasyMappingSwiftExample
//
//  Created by Denys Telezhkin on 20.07.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

class Person: EKObjectModel {
    var name : String!
    var email: String!
    var car : Car?
    var phones: [Phone]!
}

extension Person {
    override class func objectMapping() -> EKObjectMapping{
        var mapping = EKObjectMapping(objectClass: self)
        
        mapping.mapPropertiesFromArray(["name","email"])

        mapping.hasOne(Car.self, forKeyPath: "car")
        mapping.hasMany(Phone.self, forKeyPath: "phones")
        return mapping
    }
}

