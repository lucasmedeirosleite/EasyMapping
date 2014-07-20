//
//  Person.swift
//  EasyMappingSwiftExample
//
//  Created by Denys Telezhkin on 20.07.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

enum Gender {
    case Male
    case Female
}

@objc class Person: EKObjectModel {
    var name : String!
    var email: String!
    var gender: Gender!
    var car : Car?
    var phones: [Person]!
}

extension Person {
    override class func objectMapping() -> EKObjectMapping{
        var mapping = EKObjectMapping(objectClass: self)
        
        mapping.mapPropertiesFromArray(["name","email"])
//        mapping.mapKeyPath("gender", toProperty: "gender", withValueBlock: {key,value in
//            switch value as String
//                {
//            case "male":
//                return Gender.Male
//            case "female":
//                return Gender.Female
//            }
//            })
        mapping.hasOne(Car.self, forKeyPath: "car")
        mapping.hasMany(Phone.self, forKeyPath: "phones")
        return mapping
    }
}

