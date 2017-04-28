//
//  EKRelationshipMapping.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 14.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKRelationshipMapping.h"

@implementation EKRelationshipMapping

-(EKObjectMapping *)mappingForRepresentation:(id)representation {
    if (self.mappingResolver) {
        return self.mappingResolver(representation);
    }
    return [[self objectClass] objectMapping];
}

-(EKObjectMapping *)mappingForObject:(id)object {
    if (self.serializationResolver) {
        return self.serializationResolver(object);
    }
    return [[self objectClass] objectMapping];
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
    
+(instancetype)mappingForClass:(Class<EKMappingProtocol>)objectClass withKeyPath:(NSString *)keyPath forProperty:(NSString *)property {
    EKRelationshipMapping * mapping = [EKRelationshipMapping new];
    mapping.objectClass = objectClass;
    mapping.keyPath = keyPath;
    mapping.property = property;
    return mapping;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _keyPath = @"";
        _property = @"";
    }
    return self;
}

@end
