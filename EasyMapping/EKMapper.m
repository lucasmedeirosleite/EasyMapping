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
    id object = [[mapping.objectClass alloc] init];
    return [self fillObject:object fromExternalRepresentation:externalRepresentation withMapping:mapping];
}

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSManagedObject* object = [self getExistingObjectFromExternalRepresentation:externalRepresentation withMapping:mapping inManagedObjectContext:moc];
    if (!object)
        object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName inManagedObjectContext:moc];
    return [self fillObject:object fromExternalRepresentation:externalRepresentation withMapping:mapping inManagedObjectContext:moc];
}

+ (id)getExistingObjectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext *)moc {
    EKFieldMapping *primaryKeyFieldMapping = [mapping.fieldMappings objectForKey:mapping.primaryKey];
    id primaryKeyValue = [self getValueOfField:primaryKeyFieldMapping fromRepresentation:externalRepresentation];
    if (!primaryKeyValue)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:mapping.entityName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", mapping.primaryKey, primaryKeyValue]];
    
    NSArray *array = [moc executeFetchRequest:request error:NULL];
    if (array.count == 0)
        return nil;
    
    return [array lastObject];
}

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKObjectMapping *)mapping {
    NSDictionary *representation = [self extractRootPathFromExternalRepresentation:externalRepresentation withMapping:mapping];
    [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setField:obj onObject:object fromRepresentation:representation];
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

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation
     withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSDictionary *representation = [self extractRootPathFromExternalRepresentation:externalRepresentation withMapping:mapping];
    [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setField:obj onObject:object fromRepresentation:representation];
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

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation withMapping:(EKObjectMapping *)mapping
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        id parsedObject = [self objectFromExternalRepresentation:representation withMapping:mapping];
        [array addObject:parsedObject];
    }
    return [NSArray arrayWithArray:array];
}

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKManagedObjectMapping *)mapping
                               inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        id parsedObject = [self objectFromExternalRepresentation:representation withMapping:mapping inManagedObjectContext:moc];
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

+ (void)setField:(EKFieldMapping *)fieldMapping onObject:(id)object fromRepresentation:(NSDictionary *)representation
{
    id value = [self getValueOfField:fieldMapping fromRepresentation:representation];
    [object setValue:value forKeyPath:fieldMapping.field];
}

+ (id)getValueOfField:(EKFieldMapping *)fieldMapping fromRepresentation:(NSDictionary *)representation
{
    id value;
    if (fieldMapping.valueBlock) {
        value = fieldMapping.valueBlock(fieldMapping.keyPath, [representation valueForKeyPath:fieldMapping.keyPath]);
    } else if (fieldMapping.dateFormat) {
        value = [EKTransformer transformString:[representation valueForKeyPath:fieldMapping.keyPath] withDateFormat:fieldMapping.dateFormat];
    } else {
        value = [representation valueForKeyPath:fieldMapping.keyPath];
    }
    if (value == (id)[NSNull null])
        value = nil;
    return value;
}

@end
