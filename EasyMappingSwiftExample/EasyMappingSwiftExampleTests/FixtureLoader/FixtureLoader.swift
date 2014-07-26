//
//  FixtureLoader.swift
//  EasyMappingSwiftExample
//
//  Created by Denys Telezhkin on 20.07.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

class FixtureLoader: NSObject {
    
    class func jsonObjectFromFileNamed(#name : String) -> AnyObject? {
        let bundle = NSBundle(forClass: self)
        let path = bundle.pathForResource(name, ofType: "json")
        let data = NSData(contentsOfFile: path)
        
        let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)

        return parsedObject
    }
}
