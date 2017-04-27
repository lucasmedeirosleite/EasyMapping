//
//  Phone.swift
//  EasyMappingSwiftExample
//
//  Created by Denys Telezhkin on 20.07.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

class Phone: EKObjectModel {
    var DDI: String?
    var DDD: String?
    var number: String?
}

extension Phone {
    override class func objectMapping() -> EKObjectMapping
    {
        var mapping = EKObjectMapping(objectClass: self)
        
        mapping.mapPropertiesFromArray(["number"])
        mapping.mapPropertiesFromDictionary(["ddi":"DDI","ddd":"DDD"])
        
        return mapping
    }
}
