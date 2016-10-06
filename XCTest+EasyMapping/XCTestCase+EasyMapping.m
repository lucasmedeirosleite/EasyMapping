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

- (id)testObjectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKObjectMapping *)mapping expectedObject:(id)expectedObject
{
    return [self testObjectFromExternalRepresentation:externalRepresentation withMapping:mapping expectedObject:expectedObject skippingKeyPaths:nil];
}

- (id)testObjectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKObjectMapping *)mapping expectedObject:(id)expectedObject skippingKeyPaths:(NSArray *)keyPathsToSkip
{
    id mappedObject = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
    [self testMappedObject:mappedObject withMapping:mapping expectedObject:expectedObject skippingKeyPaths:keyPathsToSkip rootKeyPath:nil];
    return mappedObject;
}

- (void)testMappedObject:(id)mappedObject withMapping:(EKObjectMapping *)mapping expectedObject:(id)expectedObject skippingKeyPaths:(NSArray *)keyPathsToSkip rootKeyPath:(NSString *)rootKeyPath
{
    for (EKPropertyMapping *propertyMapping in mapping.propertyMappings.allValues) {
        NSString *keyPath = propertyMapping.property;
        if ([keyPathsToSkip containsObject:keyPath]) {
            continue;
        }
        id mappedValue = [mappedObject valueForKeyPath:keyPath];
        id expectedValue = [expectedObject valueForKeyPath:keyPath];
        NSString *keyPathString = [self keyPathByAppendingKeyPath:keyPath
                                                    toRootKeyPath:rootKeyPath];
        XCTAssertEqualObjects(mappedValue, expectedValue, "Mapping failed on keypath %@. Expected value is - %@, value after mapping is - %@", keyPathString, expectedValue, mappedValue);
    }
    
    for (EKRelationshipMapping *hasOneMapping in mapping.hasOneMappings) {
        NSString *keyPath = hasOneMapping.property;
        if ([keyPathsToSkip containsObject:keyPath]) {
            continue;
        }
        id relationshipObject = [mappedObject valueForKeyPath:keyPath];
        id expectedRelationshipObject = [expectedObject valueForKeyPath:keyPath];
        NSArray *relationshipKeyPathsToSkip = [self extractRelationshipKeyPathsFromKeyPaths:keyPathsToSkip forRelationship:keyPath];
        NSString *relationshipRootKeyPath = [self keyPathByAppendingKeyPath:keyPath
                                                              toRootKeyPath:rootKeyPath];
        [self testMappedObject:relationshipObject withMapping:[hasOneMapping mappingForRepresentation:@{}] expectedObject:expectedRelationshipObject skippingKeyPaths:relationshipKeyPathsToSkip rootKeyPath:relationshipRootKeyPath];
    }
    
    for (EKRelationshipMapping *hasManyMapping in mapping.hasManyMappings) {
        NSString *keyPath = hasManyMapping.property;
        if ([keyPathsToSkip containsObject:keyPath]) {
            continue;
        }
        NSArray *relationshipObjects = [mappedObject valueForKeyPath:keyPath];
        NSArray *expectedRelationshipObjects = [expectedObject valueForKeyPath:keyPath];
        NSArray *relationshipKeyPathsToSkip = [self extractRelationshipKeyPathsFromKeyPaths:keyPathsToSkip forRelationship:keyPath];
        [relationshipObjects enumerateObjectsUsingBlock:^(id relationshipObject, NSUInteger idx, BOOL *stop) {
            id expectedRelationshipObject = expectedRelationshipObjects[idx];
            NSString *indexKeyPath = [NSString stringWithFormat:@"%@[%@]", keyPath, @(idx)];
            NSString *relationshipRootKeyPath = [self keyPathByAppendingKeyPath:indexKeyPath
                                                                  toRootKeyPath:rootKeyPath];
            [self testMappedObject:relationshipObject withMapping:[hasManyMapping mappingForRepresentation:@{}] expectedObject:expectedRelationshipObject skippingKeyPaths:relationshipKeyPathsToSkip rootKeyPath:relationshipRootKeyPath];
        }];
    }
}

- (NSDictionary *)testSerializeObject:(id)object withMapping:(EKObjectMapping *)mapping expectedRepresentation:(NSDictionary *)expectedRepresentation
{
    return [self testSerializeObject:object withMapping:mapping expectedRepresentation:expectedRepresentation skippingKeyPaths:nil];
}

- (NSDictionary *)testSerializeObject:(id)object withMapping:(EKObjectMapping *)mapping expectedRepresentation:(NSDictionary *)expectedRepresentation skippingKeyPaths:(NSArray *)keyPathsToSkip
{
    NSDictionary *serializedObject = [EKSerializer serializeObject:object withMapping:mapping];
    [self testSerializedObject:serializedObject withMapping:mapping expectedRepresentation:expectedRepresentation skippingKeyPaths:keyPathsToSkip rootKeyPath:nil];
    return serializedObject;
}

- (void)testSerializedObject:(NSDictionary *)serializedObject withMapping:(EKObjectMapping *)mapping expectedRepresentation:(NSDictionary *)expectedRepresentation skippingKeyPaths:(NSArray *)keyPathsToSkip rootKeyPath:(NSString *)rootKeyPath
{
    for (EKPropertyMapping *propertyMapping in mapping.propertyMappings.allValues) {
        NSString *keyPath = propertyMapping.keyPath;
        if ([keyPathsToSkip containsObject:keyPath]) {
            continue;
        }
        id propertyValue = [serializedObject valueForKeyPath:keyPath];
        id expectedValue = [expectedRepresentation valueForKeyPath:keyPath];
        NSString *propertyKeyPath = [self keyPathByAppendingKeyPath:keyPath toRootKeyPath:rootKeyPath];
        XCTAssertEqualObjects(propertyValue, expectedValue, "Serialization failed on keypath %@. Expected value is - %@, value after serialization is - %@", propertyKeyPath, expectedValue, propertyValue);
    }
    
    for (EKRelationshipMapping *hasOneMapping in mapping.hasOneMappings) {
        if (hasOneMapping.keyPath) {
            NSString *keyPath = hasOneMapping.keyPath;
            if ([keyPathsToSkip containsObject:keyPath]) {
                continue;
            }
            id relationshipRepresentation = [serializedObject valueForKeyPath:keyPath];
            id expectedRelationshipRepresentation = [expectedRepresentation valueForKeyPath:keyPath];
            NSArray *relationshipKeyPathsToSkip = [self extractRelationshipKeyPathsFromKeyPaths:keyPathsToSkip forRelationship:keyPath];
            NSString *relationshipRootKeyPath = [self keyPathByAppendingKeyPath:keyPath
                                                                  toRootKeyPath:rootKeyPath];
            [self testSerializedObject:relationshipRepresentation withMapping:[hasOneMapping mappingForObject:relationshipRepresentation] expectedRepresentation:expectedRelationshipRepresentation skippingKeyPaths:relationshipKeyPathsToSkip rootKeyPath:relationshipRootKeyPath];
        }
        else {
            [self testSerializedObject:serializedObject withMapping:[hasOneMapping mappingForObject:@{}] expectedRepresentation:expectedRepresentation skippingKeyPaths:keyPathsToSkip rootKeyPath:rootKeyPath];
        }
    }
    
    for (EKRelationshipMapping *hasManyMapping in mapping.hasManyMappings) {
        NSString *keyPath = hasManyMapping.keyPath;
        if ([keyPathsToSkip containsObject:keyPath]) {
            continue;
        }
        NSArray *relationshipRepresentations = [serializedObject valueForKeyPath:keyPath];
        NSArray *expectedRelationshipRepresentations = [expectedRepresentation valueForKeyPath:keyPath];
        NSArray *relationshipKeyPathsToSkip = [self extractRelationshipKeyPathsFromKeyPaths:keyPathsToSkip forRelationship:keyPath];
        [relationshipRepresentations enumerateObjectsUsingBlock:^(id relationshipRepresentation, NSUInteger idx, BOOL *stop) {
            id expectedRelationshipRepresentation = expectedRelationshipRepresentations[idx];
            NSString *indexKeyPath = [NSString stringWithFormat:@"%@[%@]", keyPath, @(idx)];
            NSString *relationshipRootKeyPath = [self keyPathByAppendingKeyPath:indexKeyPath
                                                                  toRootKeyPath:rootKeyPath];
            [self testSerializedObject:relationshipRepresentation withMapping:[hasManyMapping mappingForObject:serializedObject] expectedRepresentation:expectedRelationshipRepresentation skippingKeyPaths:relationshipKeyPathsToSkip rootKeyPath:relationshipRootKeyPath];
        }];
    }
}

#pragma mark - Helpers

- (NSArray *)extractRelationshipKeyPathsFromKeyPaths:(NSArray *)keyPaths forRelationship:(NSString *)property
{
    NSMutableArray *mKeyPaths = [NSMutableArray new];
    for (NSString *keyPath in keyPaths) {
        NSString *pathPrefix = [NSString stringWithFormat:@"%@.", property];
        if ([keyPath hasPrefix:pathPrefix]) {
            NSString *_keyPath = [keyPath substringFromIndex:pathPrefix.length];
            [mKeyPaths addObject:_keyPath];
        }
    }
    return [mKeyPaths copy];
}

- (NSString *)keyPathByAppendingKeyPath:(NSString *)keyPath toRootKeyPath:(NSString *)rootKeyPath
{
    if (!rootKeyPath) {
        return keyPath;
    }
    else if (!keyPath) {
        return rootKeyPath;
    }
    else {
        return [NSString stringWithFormat:@"%@.%@", rootKeyPath, keyPath];
    }
}

@end
