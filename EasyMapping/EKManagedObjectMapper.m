//
//  EKManagedObjectMapper.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 10.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKManagedObjectMapper.h"
#import "EKFieldMapping.h"
#import "EKPropertyHelper.h"

@implementation EKManagedObjectMapper

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSManagedObject* object = [self getExistingObjectFromExternalRepresentation:externalRepresentation withMapping:mapping inManagedObjectContext:moc];
    if (!object)
        object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName inManagedObjectContext:moc];
    return [self fillObject:object fromExternalRepresentation:externalRepresentation withMapping:mapping inManagedObjectContext:moc];
}

+ (id)getExistingObjectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext *)moc {
    EKFieldMapping *primaryKeyFieldMapping = [mapping.fieldMappings objectForKey:mapping.primaryKey];
    id primaryKeyValue = [EKPropertyHelper getValueOfField:primaryKeyFieldMapping fromRepresentation:externalRepresentation];
    if (!primaryKeyValue || primaryKeyValue == (id)[NSNull null])
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:mapping.entityName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", mapping.primaryKey, primaryKeyValue]];
    
    NSArray *array = [moc executeFetchRequest:request error:NULL];
    if (array.count == 0)
        return nil;
    
    return [array lastObject];
}

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation
     withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSDictionary *representation = [EKPropertyHelper extractRootPathFromExternalRepresentation:externalRepresentation withMapping:mapping];
    [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [EKPropertyHelper setField:obj onObject:object fromRepresentation:representation];
    }];
    [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary* value = [representation valueForKeyPath:key];
        if (value != (id)[NSNull null]) {
            id result = [self objectFromExternalRepresentation:value withMapping:obj inManagedObjectContext:moc];
            EKObjectMapping * valueMapping = obj;
            [object setValue:result forKeyPath:valueMapping.field];
        }
    }];
    [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *arrayToBeParsed = [representation valueForKeyPath:key];
        if (arrayToBeParsed != (id)[NSNull null]) {
            NSArray *parsedArray = [self arrayOfObjectsFromExternalRepresentation:arrayToBeParsed withMapping:obj inManagedObjectContext:moc];
            id parsedObjects = [EKPropertyHelper propertyRepresentation:parsedArray
                                                              forObject:object
                                                       withPropertyName:[obj field]];
            EKObjectMapping * valueMapping = obj;
            [object setValue:parsedObjects forKeyPath:valueMapping.field];
        }
    }];
    return object;
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

+ (NSArray *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                              withMapping:(EKManagedObjectMapping *)mapping
                                             fetchRequest:(NSFetchRequest*)fetchRequest
                                   inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSAssert(mapping.primaryKey, @"A mapping with a primary key is required");
    EKFieldMapping* primaryKeyFieldMapping = [mapping.fieldMappings objectForKey:mapping.primaryKey];
    
    // Create a dictionary that maps primary keys to existing objects
    NSArray* existing = [moc executeFetchRequest:fetchRequest error:NULL];
    NSDictionary* existingByPK = [NSDictionary dictionaryWithObjects:existing forKeys:[existing valueForKey:primaryKeyFieldMapping.field]];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        // Look up the object by its primary key
        id primaryKeyValue = [EKPropertyHelper getValueOfField:primaryKeyFieldMapping fromRepresentation:representation];
        id object = [existingByPK objectForKey:primaryKeyValue];
        
        // Create a new object if necessary
        if (!object)
            object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName inManagedObjectContext:moc];
        
        [self fillObject:object fromExternalRepresentation:representation withMapping:mapping inManagedObjectContext:moc];
        [array addObject:object];
    }
    
    // Any object returned by the fetch request not in the external represntation has to be deleted
    NSMutableSet* toDelete = [NSMutableSet setWithArray:existing];
    [toDelete minusSet:[NSSet setWithArray:array]];
    for (NSManagedObject* o in toDelete)
        [moc deleteObject:o];
    
    return [NSArray arrayWithArray:array];
}

@end
