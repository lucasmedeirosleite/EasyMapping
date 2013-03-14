//
//  EKManagedObjectMapper.m
//  EasyMappingExample
//
//  Created by Alejandro Isaza on 2013-03-13.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import "EKManagedObjectMapper.h"
#import "EKFieldMapping.h"
#import "EKTransformer.h"

@implementation EKManagedObjectMapper

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext*)moc
{
    NSManagedObject* object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName inManagedObjectContext:moc];
    return [self fillObject:object fromExternalRepresentation:externalRepresentation withMapping:mapping inManagedObjectContext:moc];
}

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext*)moc {
    NSDictionary *representation = [self extractRootPathFromExternalRepresentation:externalRepresentation withMapping:mapping];
    [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setField:obj onObject:object fromRepresentation:representation withObjectMapping:mapping];
    }];
    [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary* externalRepresentation = [representation valueForKeyPath:key];
        if (externalRepresentation) {
            id result = [self objectFromExternalRepresentation:externalRepresentation withMapping:obj inManagedObjectContext:moc];
            [object setValue:result forKeyPath:key];
        }
    }];
    [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *arrayToBeParsed = [representation valueForKeyPath:key];
        if (arrayToBeParsed) {
            NSArray *parsedArray = [self arrayOfObjectsFromExternalRepresentation:arrayToBeParsed withMapping:obj inManagedObjectContext:moc];
            [object setValue:[NSSet setWithArray:parsedArray] forKeyPath:key];
        }
    }];
    return object;
}

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext*)moc
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        id parsedObject = [self objectFromExternalRepresentation:representation withMapping:mapping inManagedObjectContext:moc];
        [array addObject:parsedObject];
    }
    return [NSArray arrayWithArray:array];
}

+ (NSDictionary *)extractRootPathFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping
{
    if (mapping.rootPath) {
        return [externalRepresentation objectForKey:mapping.rootPath];
    }
    return externalRepresentation;
}

+ (void)setField:(EKFieldMapping *)fieldMapping onObject:(id)object fromRepresentation:(NSDictionary *)representation withObjectMapping:(EKManagedObjectMapping *)objectMapping
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
