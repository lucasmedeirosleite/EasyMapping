//
//  EKCoreDataImporter.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 10.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKCoreDataImporter.h"
#import "EKPropertyHelper.h"
#import "NSArray+FlattenArray.h"

@interface EKCoreDataImporter()
@property (nonatomic, strong) NSSet * entityNames;

// Keys are entity names, values - NSSet with primary keys
@property (nonatomic, strong) NSDictionary * existingEntitiesPrimaryKeys;

// Keys are entity names, values - NSDictionary, where keys = primary keys, values = fetched objects
@property (nonatomic, strong) NSDictionary * fetchedExistingEntities;

@end

@implementation EKCoreDataImporter

+(instancetype)importerWithMapping:(EKManagedObjectMapping *)mapping
            externalRepresentation:(id)externalRepresentation
                           context:(NSManagedObjectContext *)context
{
    EKCoreDataImporter * importer = [self new];
    
    importer.mapping = mapping;
    importer.externalRepresentation = externalRepresentation;
    importer.context = context;
    
    importer.existingEntitiesPrimaryKeys = [NSMutableDictionary dictionary];
    [importer collectEntityNames];
    [importer inspectRepresentation];
    
    return importer;
}

#pragma mark - collect entity names

-(void)collectEntityNames
{
    NSMutableSet * entityNames = [NSMutableSet set];
    
    [self collectEntityNamesRecursively:entityNames mapping:self.mapping];
    
    self.entityNames = [entityNames copy];
}

-(void)collectEntityNamesRecursively:(NSMutableSet *)entityNames mapping:(EKManagedObjectMapping *)mapping
{
    [entityNames addObject:mapping.entityName];
    
    for (EKManagedObjectMapping * oneMapping in [mapping.hasOneMappings allValues])
    {
        [self collectEntityNamesRecursively:entityNames mapping:oneMapping];
    }
    
    for (EKManagedObjectMapping * manyMapping in [mapping.hasManyMappings allValues])
    {
        [self collectEntityNamesRecursively:entityNames mapping:manyMapping];
    }
}

#pragma mark - Inspecting representation

-(void)inspectRepresentation
{
    NSMutableDictionary * existingPrimaryKeys = [NSMutableDictionary dictionary];
    for (NSString * entityName in self.entityNames)
    {
        existingPrimaryKeys[entityName] = [NSSet set];
    }
    [self inspectRepresentation:self.externalRepresentation
                   usingMapping:self.mapping
               accumulateInside:existingPrimaryKeys];
    
    self.existingEntitiesPrimaryKeys = [existingPrimaryKeys copy];
}

-(void)inspectRepresentation:(id)representation usingMapping:(EKManagedObjectMapping *)mapping accumulateInside:(NSMutableDictionary *)dictionary
{
    id rootRepresentation = [EKPropertyHelper extractRootPathFromExternalRepresentation:representation
                                                                            withMapping:mapping];
    if ([rootRepresentation isKindOfClass:[NSArray class]])
    {
        NSMutableSet * primaryValues = [NSMutableSet set];
        for (NSDictionary * objectInfo in rootRepresentation)
        {
            id value = [self primaryKeyValueFromRepresentation:objectInfo usingMapping:mapping];
            if (value && value != (id)[NSNull null])
            {
                [primaryValues addObject:value];
            }
        }
        NSSet * knownValues = dictionary[mapping.entityName];
        dictionary[mapping.entityName] = [knownValues setByAddingObjectsFromSet:primaryValues];
    }
    else if ([rootRepresentation isKindOfClass:[NSDictionary class]])
    {
        id value = [self primaryKeyValueFromRepresentation:rootRepresentation usingMapping:mapping];
        if (value && value != (id)[NSNull null])
        {
            NSSet * knownValues = dictionary[mapping.entityName];
            dictionary[mapping.entityName] = [knownValues setByAddingObject:value];
        }
    }
    
    [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary * oneMappingRepresentation = [rootRepresentation valueForKeyPath:key];
        [self inspectRepresentation:oneMappingRepresentation
                       usingMapping:obj
                   accumulateInside:dictionary];
    }];
    [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray * manyMappingRepresentation = [rootRepresentation valueForKeyPath:key];
        
        // This is needed, because if one of the objects in array does not contain object for key, returned structure would be something like this:
        //
        // @[<null>,@[value2,value3]]
        //
        // And we are interested in flat structure.
        manyMappingRepresentation = [manyMappingRepresentation ek_flattenedArray];
        
        [self inspectRepresentation:manyMappingRepresentation
                       usingMapping:obj
                   accumulateInside:dictionary];
    }];
}

-(id)primaryKeyValueFromRepresentation:(id)representation usingMapping:(EKManagedObjectMapping *)mapping
{
    EKFieldMapping * primaryKeyMapping = [mapping primaryKeyFieldMapping];
    id primaryValue = [EKPropertyHelper getValueOfField:primaryKeyMapping
                                     fromRepresentation:representation];
    return primaryValue;
}

@end
