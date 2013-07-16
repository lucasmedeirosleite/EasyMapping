//
//  EKSerializer.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EKSerializer.h"
#import "EKFieldMapping.h"
#import "EKPropertyHelper.h"
#import "EKTransformer.h"
#import <CoreData/CoreData.h>

@implementation EKSerializer

+ (NSMutableDictionary *)serializeObject:(id)object withMapping:(EKObjectMapping *)mapping
{
    NSMutableDictionary *representation = [NSMutableDictionary dictionary];

    [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKFieldMapping *fieldMapping, BOOL *stop) {
        [self setValueOnRepresentation:representation fromObject:object withFieldMapping:fieldMapping];
    }];
    [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKObjectMapping *objectMapping, BOOL *stop) {
        [self setHasOneMappingObjectOn:representation withObjectMapping:objectMapping fromObject:object];
    }];
    [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKObjectMapping *objectMapping, BOOL *stop) {
        [self setHasManyMappingObjectOn:representation withObjectMapping:objectMapping fromObject:object];
    }];
    
    if (mapping.rootPath.length > 0) {
        representation = [@{mapping.rootPath : representation} mutableCopy];
    }
    return representation;
}

+ (NSMutableDictionary *)serializeUsingEntityMappingCoreDataForObject:(id)object withObjectMapping:(EKObjectMapping *)objectMapping
{
    NSMutableDictionary *representation = [NSMutableDictionary dictionary];
    EKObjectMapping *mapping=nil;
    NSString *jsonMapMethod = nil;
    
    // Get the json map method from the core data entity userinfo dictionary
    if ([object isKindOfClass:[NSManagedObject class]]){
        NSManagedObject *managedObject=object;
        NSEntityDescription *entityDescription = managedObject.entity;
        //    NSAttributeDescription *attributeDescription = entityDescription.attributesByName[@"someAttribute"];
        jsonMapMethod = entityDescription.userInfo[@"jsonMap"];
    } else {
        mapping = objectMapping;
    }

    if (jsonMapMethod != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        mapping = [[object class] performSelector:NSSelectorFromString(jsonMapMethod)];
#pragma clang diagnostic pop
    }

    if (mapping != nil) {
        [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKFieldMapping *fieldMapping, BOOL *stop) {
            [self setValueOnRepresentation:representation fromObject:object withFieldMapping:fieldMapping];
        }];
        [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKObjectMapping *objectMapping, BOOL *stop) {
            [self setCoreDataHasOneMappingObjectOn:representation withParentObjectMapping:objectMapping fromObject:object];
        }];
        [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKObjectMapping *objectMapping, BOOL *stop) {
            [self setCoreDataHasManyMappingObjectOn:representation withParentObjectMapping:objectMapping fromObject:object];
        }];

        if (mapping.rootPath.length > 0) {
            representation = [@{mapping.rootPath : representation} mutableCopy];
        }
    }
    return representation;

    return representation;
}

//+ (NSDictionary *)serializeCoreDataObject:(id)object withClosestMappingFromList:(NSArray*)mappingList
//{
//    int maxKeyMatches = 0;
//    int mappingIndexWithMostMatches = -1;
//    EKObjectMapping *mapping = nil;
//
//    for (int i=0; i < [mappingList count]; i++) {
//        mapping = [mappingList objectAtIndex:i];
//        int currentObjectCount = 0;
//        for (id selectorName in [mapping.fieldMappings allKeys]) {
//            if ([object respondsToSelector:NSSelectorFromString(selectorName)]) {
//                currentObjectCount++;
//            }
//        }
//
//        for (id selectorName in [mapping.hasOneMappings allKeys]) {
//            if ([object respondsToSelector:NSSelectorFromString(selectorName)]) {
//                currentObjectCount++;
//            }
//        }
//
//        for (id selectorName in [mapping.hasManyMappings allKeys]) {
//            if ([object respondsToSelector:NSSelectorFromString(selectorName)]) {
//                currentObjectCount++;
//            }
//        }
//
//        // Keep a running total of the best mapping
//        if (currentObjectCount > maxKeyMatches) {
//            maxKeyMatches = currentObjectCount;
//            mappingIndexWithMostMatches = i;
//        }
//    }
//
//    NSMutableDictionary *representation = [NSMutableDictionary dictionary];
//    if (mappingIndexWithMostMatches >= 0) {
//        mapping = [mappingList objectAtIndex:mappingIndexWithMostMatches];
//        [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKFieldMapping *fieldMapping, BOOL *stop) {
//            [self setValueOnRepresentation:representation fromObject:object withFieldMapping:fieldMapping];
//        }];
//        [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKObjectMapping *objectMapping, BOOL *stop) {
//            [self setHasOneMappingObjectOn:representation withObjectMapping:objectMapping fromObject:object];
//        }];
//        [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKObjectMapping *objectMapping, BOOL *stop) {
//            [self setHasManyMappingObjectOn:representation withObjectMapping:objectMapping fromObject:object];
//        }];
//
//        if (mapping.rootPath.length > 0) {
//            representation = [@{mapping.rootPath : representation} mutableCopy];
//        }
//    }
//    return representation;
//}

+ (NSArray *)serializeCollection:(NSArray *)collection withMapping:(EKObjectMapping *)mapping
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id object in collection) {
        NSDictionary *objectRepresentation = [self serializeObject:object withMapping:mapping];
        [array addObject:objectRepresentation];
    }
    
    return [NSArray arrayWithArray:array];
}

+ (void)setValueOnRepresentation:(NSMutableDictionary *)representation fromObject:(id)object withFieldMapping:(EKFieldMapping *)fieldMapping
{
    SEL selector = NSSelectorFromString(fieldMapping.field);
    if ([EKPropertyHelper propertyNameIsNative:fieldMapping.field fromObject:object]) {
    
        if (fieldMapping.reverseBlock) {
            id returnedValue = [EKPropertyHelper perfomSelector:selector onObject:object];
            id reverseValue = fieldMapping.reverseBlock(returnedValue);
            [self setValue:reverseValue forKeyPath:fieldMapping.keyPath inRepresentation:representation];
        }
        
    } else {
        
        id returnedValue = [EKPropertyHelper perfomSelector:selector onObject:object];
        if (returnedValue) {
            if (fieldMapping.reverseBlock) {
                id reverseValue = fieldMapping.reverseBlock(returnedValue);
                [self setValue:reverseValue forKeyPath:fieldMapping.keyPath inRepresentation:representation];
            } else if (fieldMapping.dateFormat && [returnedValue isKindOfClass:[NSDate class]]) {
                NSString *reverseValue = [EKTransformer transformDate:returnedValue withDateFormat:fieldMapping.dateFormat];
                [self setValue:reverseValue forKeyPath:fieldMapping.keyPath inRepresentation:representation];
            } else {
                [self setValue:returnedValue forKeyPath:fieldMapping.keyPath inRepresentation:representation];
            }
        }
    }
}

+ (void)setValue:(id)value forKeyPath:(NSString *)keyPath inRepresentation:(NSMutableDictionary *)representation {
    NSArray *keyPathComponents = [keyPath componentsSeparatedByString:@"."];
    if ([keyPathComponents count] == 1) {
        [representation setObject:value forKey:keyPath];
    } else if ([keyPathComponents count] > 1) {
        NSString *attributeKey = [keyPathComponents lastObject];
        NSMutableArray *subPaths = [NSMutableArray arrayWithArray:keyPathComponents];
        [subPaths removeLastObject];
        
        id currentPath = representation;
        for (NSString *key in subPaths) {
            id subPath = [currentPath valueForKey:key];
            if (subPath == nil) {
                subPath = [NSMutableDictionary new];
                [currentPath setValue:subPath forKey:key];
            }
            currentPath = subPath;
        }
        [currentPath setValue:value forKey:attributeKey];
    }
}


+ (void)setHasOneMappingObjectOn:(NSMutableDictionary *)representation
               withObjectMapping:(EKObjectMapping *)mapping
                      fromObject:(id)object
{
    id hasOneObject = [EKPropertyHelper perfomSelector:NSSelectorFromString(mapping.field) onObject:object];
    if (hasOneObject) {
        NSDictionary *hasOneRepresentation = [self serializeObject:hasOneObject withMapping:mapping];
        [representation setObject:hasOneRepresentation forKey:mapping.keyPath];
    }
}

+ (void)setHasManyMappingObjectOn:(NSMutableDictionary *)representation
                withObjectMapping:(EKObjectMapping *)mapping
                       fromObject:(id)object
{
    id hasManyObject = [EKPropertyHelper perfomSelector:NSSelectorFromString(mapping.field) onObject:object];
    if (hasManyObject) {
        NSArray *hasManyRepresentation = [self serializeCollection:hasManyObject withMapping:mapping];
        [representation setObject:hasManyRepresentation forKey:mapping.keyPath];
    }
}

+ (NSMutableDictionary *)serializeCoreDataObject:(id)object withMapping:(EKObjectMapping *)mapping
{
    NSMutableDictionary *representation = [NSMutableDictionary dictionary];
    EKObjectMapping *objectMapping = mapping;
    // Get the json map method from the core data entity userinfo dictionary
    NSManagedObject *managedObject=object;
    NSEntityDescription *entityDescription = managedObject.entity;
    bool coreDataObject = NO;
    //    NSAttributeDescription *attributeDescription = entityDescription.attributesByName[@"someAttribute"];
    NSString *jsonMapMethod = entityDescription.userInfo[@"jsonMap"];
    if (jsonMapMethod != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        objectMapping = [[object class] performSelector:NSSelectorFromString(jsonMapMethod)];
#pragma clang diagnostic pop
        coreDataObject = YES;
    }

    [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKFieldMapping *fieldMapping, BOOL *stop) {
        [self setValueOnRepresentation:representation fromObject:object withFieldMapping:fieldMapping];
    }];
    [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKObjectMapping *objectMapping, BOOL *stop) {
        if (coreDataObject) {
            [self setCoreDataHasOneMappingObjectOn:representation withParentObjectMapping:objectMapping fromObject:object];
        } else {
            [self setHasOneMappingObjectOn:representation withObjectMapping:objectMapping fromObject:object];
        }
    }];
    [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKObjectMapping *objectMapping, BOOL *stop) {
        if (coreDataObject) {
            [self setCoreDataHasManyMappingObjectOn:representation withParentObjectMapping:objectMapping fromObject:object];
        } else {
            [self setHasManyMappingObjectOn:representation withObjectMapping:objectMapping fromObject:object];
        }
    }];

    if (mapping.rootPath.length > 0) {
        representation = [@{mapping.rootPath : representation} mutableCopy];
    }
    return representation;
}

+ (NSArray *)serializeCoreDataCollection:(NSArray *)collection withMapping:(EKObjectMapping *)mapping
{
    NSMutableArray *array = [NSMutableArray array];
    EKObjectMapping *coreDatamapping = mapping;

    for (id object in collection) {
        // Get the json map method from the core data entity userinfo dictionary
        NSManagedObject *managedObject=object;
        NSEntityDescription *entityDescription = managedObject.entity;
        //    NSAttributeDescription *attributeDescription = entityDescription.attributesByName[@"someAttribute"];
        NSString *jsonMapMethod = entityDescription.userInfo[@"jsonMap"];

        EKObjectMapping *mapping=nil;
        if (jsonMapMethod != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            coreDatamapping = [[object class] performSelector:NSSelectorFromString(jsonMapMethod)];
#pragma clang diagnostic pop
        }

        NSDictionary *objectRepresentation = [self serializeObject:object withMapping:coreDatamapping];
        [array addObject:objectRepresentation];
    }

    return [NSArray arrayWithArray:array];
}

+ (void)setCoreDataHasOneMappingObjectOn:(NSMutableDictionary *)representation
               withParentObjectMapping:(EKObjectMapping *)mapping
                      fromObject:(id)object
{
    id hasOneObject = [EKPropertyHelper perfomSelector:NSSelectorFromString(mapping.field) onObject:object];
    if (hasOneObject) {
        NSDictionary *hasOneRepresentation = [self serializeCoreDataObject:hasOneObject withMapping:mapping];
        [representation setObject:hasOneRepresentation forKey:mapping.keyPath];
    }
}

+ (void)setCoreDataHasManyMappingObjectOn:(NSMutableDictionary *)representation
                withParentObjectMapping:(EKObjectMapping *)mapping
                       fromObject:(id)object
{
    id hasManyObject = [EKPropertyHelper perfomSelector:NSSelectorFromString(mapping.field) onObject:object];
    if (hasManyObject) {
        NSArray *hasManyRepresentation = [self serializeCoreDataCollection:hasManyObject withMapping:mapping];
        [representation setObject:hasManyRepresentation forKey:mapping.keyPath];
    }
}


@end
