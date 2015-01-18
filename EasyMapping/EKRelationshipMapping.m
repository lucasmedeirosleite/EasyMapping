//
//  EKRelationshipMapping.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 14.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKRelationshipMapping.h"

@implementation EKRelationshipMapping

-(EKObjectMapping*)objectMapping
{
    return (_objectMapping == nil) ? [_objectClass objectMapping] : _objectMapping;
}

-(NSDictionary *)extractObjectFromRepresentation:(NSDictionary *)representation
{
    if (self.nonNestedKeyPaths == nil)
    {
        return [representation valueForKeyPath:self.keyPath];
    }
    else {
        NSMutableDictionary * values = [NSMutableDictionary dictionaryWithCapacity:self.nonNestedKeyPaths.count];
        
        for (NSString * keyPath in self.nonNestedKeyPaths)
        {
            id value = [representation valueForKeyPath:keyPath];
            if (value && value!=(id)[NSNull null])
            {
                values[keyPath] = value;
            }
        }
        return [values copy];
    }
}

@end
