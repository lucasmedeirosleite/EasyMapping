//
//  EKCoreDataImporter.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 10.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKCoreDataImporter.h"

@interface EKCoreDataImporter()
@property (nonatomic, strong) NSSet * entityNames;
@property (nonatomic, strong) NSMutableDictionary * existingEntities;
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
    
    importer.existingEntities = [NSMutableDictionary dictionary];
    [importer collectEntityNames];
    [importer inspectRepresentation];
    
    return importer;
}

-(void)inspectRepresentation
{
    
}

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

-(void)inspectRepresentation:(id)representation usingMapping:(EKManagedObjectMapping *)mapping
{
    
}

@end
