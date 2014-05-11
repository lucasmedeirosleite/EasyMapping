//
//  EKManagedObjectMapper.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 10.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKManagedObjectMapper.h"
#import "EKPropertyHelper.h"
#import "EKCoreDataImporter.h"

@interface EKManagedObjectMapper()
@property (nonatomic, strong) EKCoreDataImporter * importer;

+(instancetype)mapperWithImporter:(EKCoreDataImporter *)importer;

@end

@implementation EKManagedObjectMapper

+(instancetype)mapperWithImporter:(EKCoreDataImporter *)importer
{
    EKManagedObjectMapper * mapper = [self new];
    mapper.importer = importer;
    return mapper;
}

- (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                             withMapping:(EKManagedObjectMapping *)mapping
{
    NSManagedObject* object = [self.importer existingObjectForRepresentation:externalRepresentation
                                                                     mapping:mapping];
    if (!object) {
        object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName inManagedObjectContext:self.importer.context];
    }
    return [self fillObject:object
 fromExternalRepresentation:externalRepresentation
                withMapping:mapping];
}

-(id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation
      withMapping:(EKManagedObjectMapping *)mapping
{
    NSDictionary *representation = [EKPropertyHelper extractRootPathFromExternalRepresentation:externalRepresentation withMapping:mapping];
    [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [EKPropertyHelper setField:obj onObject:object fromRepresentation:representation];
    }];
    [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary* value = [representation valueForKeyPath:key];
        if (value != (id)[NSNull null]) {
            id result = [self objectFromExternalRepresentation:value withMapping:obj];
            EKObjectMapping * valueMapping = obj;
            [object setValue:result forKeyPath:valueMapping.field];
        }
    }];
    [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *arrayToBeParsed = [representation valueForKeyPath:key];
        if (arrayToBeParsed != (id)[NSNull null]) {
            NSArray *parsedArray = [self arrayOfObjectsFromExternalRepresentation:arrayToBeParsed
                                                                      withMapping:obj];
            id parsedObjects = [EKPropertyHelper propertyRepresentation:parsedArray
                                                              forObject:object
                                                       withPropertyName:[obj field]];
            EKObjectMapping * valueMapping = obj;
            [object setValue:parsedObjects forKeyPath:valueMapping.field];
        }
    }];
    return object;
}

-(NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                         withMapping:(EKManagedObjectMapping *)mapping
{
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        id parsedObject = [self objectFromExternalRepresentation:representation withMapping:mapping];
        [array addObject:parsedObject];
    }
    return [NSArray arrayWithArray:array];
}

-(NSArray *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                             withMapping:(EKManagedObjectMapping *)mapping
                                            fetchRequest:(NSFetchRequest*)fetchRequest
{
    NSAssert(mapping.primaryKey, @"A mapping with a primary key is required");
    EKFieldMapping * primaryKeyFieldMapping = [mapping primaryKeyFieldMapping];
    
    // Create a dictionary that maps primary keys to existing objects
    NSArray* existing = [self.importer.context executeFetchRequest:fetchRequest error:NULL];
    NSDictionary* existingByPK = [NSDictionary dictionaryWithObjects:existing forKeys:[existing valueForKey:primaryKeyFieldMapping.field]];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        // Look up the object by its primary key
        id primaryKeyValue = [EKPropertyHelper getValueOfField:primaryKeyFieldMapping fromRepresentation:representation];
        id object = [existingByPK objectForKey:primaryKeyValue];
        
        // Create a new object if necessary
        if (!object)
            object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName inManagedObjectContext:self.importer.context];
        
        [self fillObject:object fromExternalRepresentation:representation withMapping:mapping];
        [array addObject:object];
    }
    
    // Any object returned by the fetch request not in the external represntation has to be deleted
    NSMutableSet* toDelete = [NSMutableSet setWithArray:existing];
    [toDelete minusSet:[NSSet setWithArray:array]];
    for (NSManagedObject* o in toDelete)
        [self.importer.context deleteObject:o];
    
    return [NSArray arrayWithArray:array];
}


#pragma mark - CoreData Importer
/*
 All methods below perform a redirection to instance methods, that use CoreData importer class
 */

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext *)moc
{
    EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:mapping
                                                     externalRepresentation:externalRepresentation
                                                                    context:moc];
    return [[self mapperWithImporter:importer] objectFromExternalRepresentation:externalRepresentation
                                                                    withMapping:mapping];
}

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation
     withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext *)moc
{
    EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:mapping
                                                     externalRepresentation:externalRepresentation
                                                                    context:moc];
    return [[self mapperWithImporter:importer] fillObject:object
                               fromExternalRepresentation:externalRepresentation
                                              withMapping:mapping];
}

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKManagedObjectMapping *)mapping
                               inManagedObjectContext:(NSManagedObjectContext *)moc
{
    EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:mapping
                                                     externalRepresentation:externalRepresentation
                                                                    context:moc];
    return [[self mapperWithImporter:importer] arrayOfObjectsFromExternalRepresentation:externalRepresentation
                                                withMapping:mapping];
}

+ (NSArray *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                              withMapping:(EKManagedObjectMapping *)mapping
                                             fetchRequest:(NSFetchRequest*)fetchRequest
                                   inManagedObjectContext:(NSManagedObjectContext *)moc
{
    EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:mapping
                                                     externalRepresentation:externalRepresentation
                                                                    context:moc];
    return [[self mapperWithImporter:importer] syncArrayOfObjectsFromExternalRepresentation:externalRepresentation
                                                                                withMapping:mapping
                                                                               fetchRequest:fetchRequest];    
}

@end
