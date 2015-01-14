//
//  XCTestCase+EasyMapping.m
//  EasyMappingExample
//
//  Created by Ilya Puchka on 14.01.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import "XCTestCase+EasyMapping.h"
#import "EKPropertyHelper.h"
#import "EKObjectMapping.h"
#import "EKMapper.h"
#import "EKSerializer.h"
#import "EKRelationshipMapping.h"

@implementation XCTestCase (EasyMapping)

- (id)testMapping:(EKObjectMapping *)mapping withRepresentation:(NSDictionary *)representation expectedObject:(id)expectedObject
{
    return [self testMapping:mapping withRepresentation:representation expectedObject:expectedObject skippingKeyPaths:nil];
}

- (id)testMapping:(EKObjectMapping *)mapping withRepresentation:(NSDictionary *)representation expectedObject:(id)expectedObject skippingKeyPaths:(NSArray *)keyPathsToSkip
{
    id mappedObject = [EKMapper objectFromExternalRepresentation:representation withMapping:mapping];
    NSMutableArray *keyPathsToCheck = [NSMutableArray new];
    NSString *propertyKey = NSStringFromSelector(@selector(property));
    [keyPathsToCheck addObjectsFromArray:[mapping.propertyMappings.allValues valueForKey:propertyKey]];
    [keyPathsToCheck addObjectsFromArray:[mapping.hasOneMappings.allValues valueForKey:propertyKey]];
    [keyPathsToCheck addObjectsFromArray:[mapping.hasManyMappings.allValues valueForKey:propertyKey]];
    [keyPathsToCheck removeObjectsInArray:keyPathsToSkip];
    
    for (NSString *keyPath in keyPathsToCheck) {
        id mappedValue = [mappedObject valueForKeyPath:keyPath];
        id expectedValue = [expectedObject valueForKeyPath:keyPath];
        XCTAssertEqualObjects(mappedValue, expectedValue, "Mapping failed on keypath %@. Expected value is - %@, value after mapping is - %@", keyPath, expectedValue, mappedValue);
    }
    return mappedObject;
}

- (NSDictionary *)testSerializationUsingMapping:(EKObjectMapping *)mapping withObject:(id)object expectedRepresentation:(NSDictionary *)expectedRepresentation
{
    return [self testSerializationUsingMapping:mapping withObject:object expectedRepresentation:expectedRepresentation skippingKeyPaths:nil];
}

- (NSDictionary *)testSerializationUsingMapping:(EKObjectMapping *)mapping withObject:(id)object expectedRepresentation:(NSDictionary *)expectedRepresentation skippingKeyPaths:(NSArray *)keyPathsToSkip
{
    NSDictionary *serializedObject = [EKSerializer serializeObject:object withMapping:mapping];
    
    NSMutableArray *keyPathsToCheck = [NSMutableArray new];
    NSString *keyPathKey = NSStringFromSelector(@selector(keyPath));
    [keyPathsToCheck addObjectsFromArray:[mapping.propertyMappings.allValues valueForKey:keyPathKey]];

    [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKRelationshipMapping *relationshipMapping, BOOL *stop) {
        if (relationshipMapping.keyPath) {
            [keyPathsToCheck addObject:relationshipMapping.keyPath];
        }
        else {
            NSMutableSet *keys = [NSMutableSet new];
            [keys addObjectsFromArray:relationshipMapping.objectMapping.propertyMappings.allKeys];
            [keys addObjectsFromArray:relationshipMapping.objectMapping.hasOneMappings.allKeys];
            [keys addObjectsFromArray:relationshipMapping.objectMapping.hasManyMappings.allKeys];
            [keyPathsToCheck addObjectsFromArray:keys.allObjects];
        }
    }];
    
    [keyPathsToCheck addObjectsFromArray:[mapping.hasManyMappings.allValues valueForKey:keyPathKey]];
    [keyPathsToCheck removeObjectsInArray:keyPathsToSkip];
    
    for (NSString *keyPath in keyPathsToCheck) {
        id mappedValue = [serializedObject valueForKeyPath:keyPath];
        id expectedValue = [expectedRepresentation valueForKeyPath:keyPath];
        XCTAssertEqualObjects(mappedValue, expectedValue, "Serialization failed on keypath %@. Expected value is - %@, value after serialization is - %@", keyPath, expectedValue, mappedValue);
    }
  
    return serializedObject;
}

@end
