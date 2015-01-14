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
    if (self.keyPath) {
        return [representation valueForKeyPath:self.keyPath];
    }
    else {
        EKObjectMapping *mapping = [self objectMapping];
        NSMutableSet *keys = [NSMutableSet new];
        [keys addObjectsFromArray:mapping.propertyMappings.allKeys];
        [keys addObjectsFromArray:mapping.hasOneMappings.allKeys];
        [keys addObjectsFromArray:mapping.hasManyMappings.allKeys];
        NSDictionary *value = [representation dictionaryWithValuesForKeys:keys.allObjects];
        return value;
    }
}

@end
