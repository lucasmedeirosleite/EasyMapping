//
//  EKMapper.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EKMapper.h"
#import "EKFieldMapping.h"
#import "EKTransformer.h"

@implementation EKMapper

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKObjectMapping *)mapping
{
    NSDictionary *representation = [self extractRootPathFromExternalRepresentation:externalRepresentation withMapping:mapping];
    id object = [[mapping.objectClass alloc] init];
    [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setField:obj onObject:object fromRepresentation:representation withObjectMapping:mapping];
    }];
    [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id result = [self objectFromExternalRepresentation:[representation valueForKeyPath:key] withMapping:obj];
        [object setValue:result forKeyPath:key];
    }];
    [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *arrayToBeParsed = [representation valueForKeyPath:key];
        NSArray *parsedArray = [self arrayOfObjectsFromExternalRepresentation:arrayToBeParsed withMapping:obj];
        [object setValue:parsedArray forKeyPath:key];
    }];
    return object;
}

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation withMapping:(EKObjectMapping *)mapping
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        id parsedObject = [self objectFromExternalRepresentation:representation withMapping:mapping];
        [array addObject:parsedObject];
    }
    return [NSArray arrayWithArray:array];
}

+ (NSDictionary *)extractRootPathFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKObjectMapping *)mapping
{
    if (mapping.rootPath) {
        return [externalRepresentation objectForKey:mapping.rootPath];
    }
    return externalRepresentation;
}

+ (void)setField:(EKFieldMapping *)fieldMapping onObject:(id)object fromRepresentation:(NSDictionary *)representation withObjectMapping:(EKObjectMapping *)objectMapping
{
    id value;
    if (fieldMapping.valueBlock) {
        value = fieldMapping.valueBlock(fieldMapping.keyPath, [representation valueForKeyPath:fieldMapping.keyPath]);
    } else if (fieldMapping.dateFormat) {
        value = [EKTransformer transformString:[representation valueForKeyPath:fieldMapping.keyPath] withDateFormat:fieldMapping.dateFormat];
    } else {
        value = [representation valueForKeyPath:fieldMapping.keyPath];
    }
    [object setValue:value forKeyPath:fieldMapping.field];
}

@end
