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

@implementation EKSerializer

+ (NSDictionary *)serializeObject:(id)object withMapping:(EKObjectMapping *)mapping
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
    id returnedValue = [EKPropertyHelper performSelector:selector onObject:object];
    
    if (returnedValue) {
        
        if (fieldMapping.reverseBlock) {
            returnedValue = fieldMapping.reverseBlock(returnedValue);
        } else if (fieldMapping.dateFormat && [returnedValue isKindOfClass:[NSDate class]]) {
            returnedValue = [EKTransformer transformDate:returnedValue withDateFormat:fieldMapping.dateFormat];
        }
        
        [self setValue:returnedValue forKeyPath:fieldMapping.keyPath inRepresentation:representation];
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
    id hasOneObject = [EKPropertyHelper performSelector:NSSelectorFromString(mapping.field) onObject:object];
    if (hasOneObject) {
        NSDictionary *hasOneRepresentation = [self serializeObject:hasOneObject withMapping:mapping];
        [representation setObject:hasOneRepresentation forKey:mapping.keyPath];
    }
}

+ (void)setHasManyMappingObjectOn:(NSMutableDictionary *)representation
                withObjectMapping:(EKObjectMapping *)mapping
                       fromObject:(id)object
{
    id hasManyObject = [EKPropertyHelper performSelector:NSSelectorFromString(mapping.field) onObject:object];
    if (hasManyObject) {
        NSArray *hasManyRepresentation = [self serializeCollection:hasManyObject withMapping:mapping];
        [representation setObject:hasManyRepresentation forKey:mapping.keyPath];
    }
}


@end
