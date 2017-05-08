//
//  EasyMapping
//
//  Copyright (c) 2012-2017 Lucas Medeiros.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "EKCoreDataImporter.h"
#import "EKPropertyHelper.h"
#import "NSArray+FlattenArray.h"
#import "EKRelationshipMapping.h"
#import "EKManagedMappingContextProvider.h"

@interface EKCoreDataImporter ()

@property (nonatomic, strong) NSMutableSet * collectedEntityNames;

@property (nonatomic, strong) NSSet * entityNames;

// Keys are entity names, values - NSSet with primary keys
@property (nonatomic, strong) NSDictionary * existingEntitiesPrimaryKeys;

// Keys are entity names, values - NSDictionary, where keys = primary keys, values = fetched objects
@property (nonatomic, strong) NSMutableDictionary * fetchedExistingEntities;

@end

@implementation EKCoreDataImporter

-(instancetype)initWithContext:(NSManagedObjectContext *)context store:(EKManagedMappingStore *)store {
    self = [super init];
    if (self) {
        self.context = context;
        self.fetchedExistingEntities = [NSMutableDictionary dictionary];
        self.store = store;
    }
    return self;
}

//+ (instancetype)importerWithMapping:(EKManagedObjectMapping *)mapping
//             externalRepresentation:(id)externalRepresentation
//                            context:(NSManagedObjectContext *)context
//{
//    EKCoreDataImporter * importer = [self new];
//
//    importer.mapping = mapping;
//    importer.externalRepresentation = externalRepresentation;
//    importer.context = context;
//
//    importer.fetchedExistingEntities = [NSMutableDictionary dictionary];
//    [importer collectEntityNames];
//    [importer inspectRepresentationInContext:context];
//
//    return importer;
//}

-(void)inspectRepresentation:(id)representation withMapping:(EKObjectMapping *)mapping {
    NSParameterAssert([[mapping contextProvider] isKindOfClass:EKManagedMappingContextProvider.class]);
    
    self.externalRepresentation = representation;
    self.mapping = mapping;
    [self collectEntityNames];
    [self inspectRepresentationInContext:self.context];
}

-(void)flushAllObjects {
    self.externalRepresentation = nil;
    [self.fetchedExistingEntities removeAllObjects];
    [self.collectedEntityNames removeAllObjects];
    self.existingEntitiesPrimaryKeys = [NSDictionary dictionary];
}

#pragma mark - collect entity names

- (void)collectEntityNames
{
    NSMutableSet * entityNames = [NSMutableSet set];
    self.collectedEntityNames = [NSMutableSet set];
    
    [self collectEntityNamesRecursively:entityNames mapping:self.mapping];

    self.entityNames = [entityNames copy];
}

- (void)collectEntityNamesRecursively:(NSMutableSet *)entityNames mapping:(EKObjectMapping *)objectMapping
{
    [entityNames addObject:[(EKManagedMappingContextProvider *)[objectMapping contextProvider] entityName]];

    for (EKRelationshipMapping * oneMapping in objectMapping.hasOneMappings)
    {
        EKObjectMapping * mapping = [[oneMapping objectClass] objectMapping];
        
        NSParameterAssert([mapping.contextProvider isKindOfClass:[EKManagedMappingContextProvider class]]);
        
        EKManagedMappingContextProvider * provider = (EKManagedMappingContextProvider *)mapping.contextProvider;
        if ([self.collectedEntityNames containsObject:provider.entityName])
        {
            continue;
        }
        else {
            [self.collectedEntityNames addObject:provider.entityName];
            [self collectEntityNamesRecursively:entityNames mapping:mapping];
        }
    }

    for (EKRelationshipMapping * manyMapping in objectMapping.hasManyMappings)
    {
        EKObjectMapping * mapping = [[manyMapping objectClass] objectMapping];
        
        NSParameterAssert([mapping.contextProvider isKindOfClass:[EKManagedMappingContextProvider class]]);
        
        EKManagedMappingContextProvider * provider = (EKManagedMappingContextProvider *)mapping.contextProvider;
        if ([self.collectedEntityNames containsObject:provider.entityName])
        {
            continue;
        }
        else {
            [self.collectedEntityNames addObject:provider.entityName];
            [self collectEntityNamesRecursively:entityNames mapping:mapping];
        }
    }
}

#pragma mark - Inspecting representation

- (void)inspectRepresentationInContext:(NSManagedObjectContext *)context
{
    NSMutableDictionary * existingPrimaryKeys = [NSMutableDictionary dictionary];
    for (NSString * entityName in self.entityNames)
    {
        existingPrimaryKeys[entityName] = [NSMutableSet set];
    }
    [self inspectRepresentation:self.externalRepresentation
                   usingMapping:self.mapping
               accumulateInside:existingPrimaryKeys];

    self.existingEntitiesPrimaryKeys = existingPrimaryKeys;
}

- (void)inspectRepresentation:(id)representation
                 usingMapping:(EKObjectMapping *)mapping
             accumulateInside:(NSMutableDictionary *)dictionary
{
    id rootRepresentation = [EKPropertyHelper extractRootPathFromExternalRepresentation:representation
                                                                            withMapping:mapping];
    EKManagedMappingContextProvider * provider = (EKManagedMappingContextProvider * )mapping.contextProvider;
    if ([rootRepresentation isKindOfClass:[NSArray class]])
    {
        for (NSDictionary * objectInfo in rootRepresentation)
        {
            id value = [self primaryKeyValueFromRepresentation:objectInfo usingMapping:mapping];
            if (value && value != (id)[NSNull null])
            {
                [(NSMutableSet *)dictionary[provider.entityName] addObject:value];
            }
        }
    }
    else if ([rootRepresentation isKindOfClass:[NSDictionary class]])
    {
        id value = [self primaryKeyValueFromRepresentation:rootRepresentation usingMapping:mapping];
        if (value && value != (id)[NSNull null])
        {
            [(NSMutableSet *)dictionary[provider.entityName] addObject:value];
        }
    }

    for (EKRelationshipMapping *relationship in mapping.hasOneMappings)
    {
        id oneMappingRepresentation = [rootRepresentation valueForKeyPath:relationship.keyPath];
        if (oneMappingRepresentation && ![oneMappingRepresentation isEqual:[NSNull null]])
        {
            // This is needed, because if one of the objects in array does not contain object for key, returned structure would be something like this:
            //
            // @[<null>,@[value2,value3]]
            //
            // And we are interested in flat structure like this: @[value2,value3]
            if ([oneMappingRepresentation isKindOfClass:[NSArray class]]) {
                oneMappingRepresentation = [oneMappingRepresentation ek_flattenedCompactedArray];

                // if after compact, the array is empty, we should skip this
                if ([oneMappingRepresentation count] == 0) {
                    continue;
                }
            }

            [self inspectRepresentation:oneMappingRepresentation
                           usingMapping:[relationship mappingForRepresentation:oneMappingRepresentation]
                       accumulateInside:dictionary];
        }
    }

    for (EKRelationshipMapping *relationship in mapping.hasManyMappings)
    {
        NSArray * manyMappingRepresentation = [rootRepresentation valueForKeyPath:relationship.keyPath];

        if (manyMappingRepresentation && ![manyMappingRepresentation isEqual:[NSNull null]])
        {
            // This is needed, because if one of the objects in array does not contain object for key, returned structure would be something like this:
            //
            // @[<null>,@[value2,value3]]
            //
            // And we are interested in flat structure like this: @[value2,value3]
            manyMappingRepresentation = [manyMappingRepresentation ek_flattenedCompactedArray];

            // if after compact, the array is empty, we should skip this
            if ([manyMappingRepresentation count] == 0) {
                continue;
            }

            [self inspectRepresentation:manyMappingRepresentation
                           usingMapping:[relationship mappingForRepresentation:manyMappingRepresentation]
                       accumulateInside:dictionary];
        }
    }
}

- (id)primaryKeyValueFromRepresentation:(id)representation usingMapping:(EKObjectMapping *)mapping {
    EKPropertyMapping * primaryKeyMapping = [mapping primaryKeyPropertyMapping];
    return [EKPropertyHelper getValueOfProperty:primaryKeyMapping
                             fromRepresentation:representation
                                        inStore:self.store
                                contextProvider:mapping.contextProvider];
}

#pragma mark - Fetching existing objects

- (NSMutableDictionary *)fetchExistingObjectsForMapping:(EKObjectMapping *)mapping
{
    EKManagedMappingContextProvider * provider = (EKManagedMappingContextProvider * )mapping.contextProvider;
    NSSet * lookupValues = self.existingEntitiesPrimaryKeys[provider.entityName];
    if (lookupValues.count == 0) return [NSMutableDictionary dictionary];

    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:provider.entityName];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K IN %@", provider.primaryKey, lookupValues];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:lookupValues.count];

    NSMutableDictionary * output = [NSMutableDictionary new];
    NSArray * existingObjects = [self.context executeFetchRequest:fetchRequest error:NULL];
    for (NSManagedObject * object in existingObjects)
    {
        output[[object valueForKey:provider.primaryKey]] = object;
    }

    return output;
}

- (NSMutableDictionary *)cachedObjectsForMapping:(EKObjectMapping *)mapping
{
    EKManagedMappingContextProvider * provider = (EKManagedMappingContextProvider * )mapping.contextProvider;
    NSMutableDictionary * entityObjectsMap = self.fetchedExistingEntities[provider.entityName];
    if (!entityObjectsMap)
    {
        entityObjectsMap = [self fetchExistingObjectsForMapping:mapping];
        self.fetchedExistingEntities[provider.entityName] = entityObjectsMap;
    }

    return entityObjectsMap;
}

- (id)existingObjectForRepresentation:(id)representation mapping:(EKObjectMapping *)mapping
{
    NSParameterAssert([mapping.contextProvider isKindOfClass:[EKManagedMappingContextProvider class]]);
    
    NSDictionary * entityObjectsMap = [self cachedObjectsForMapping:mapping];

    id primaryKeyValue = [EKPropertyHelper getValueOfProperty:[mapping primaryKeyPropertyMapping]
                                           fromRepresentation:representation
                                                      inStore:self.store
                                              contextProvider:mapping.contextProvider];
    if (primaryKeyValue == nil || primaryKeyValue == NSNull.null) return nil;

    return entityObjectsMap[primaryKeyValue];
}

-(void)cacheObject:(NSManagedObject *)object withMapping:(EKObjectMapping *)mapping
{
    NSParameterAssert([mapping.contextProvider isKindOfClass:[EKManagedMappingContextProvider class]]);
    
    EKManagedMappingContextProvider * provider = (EKManagedMappingContextProvider * )mapping.contextProvider;
    
    if(!provider.primaryKey) return;
    if (![object valueForKey:provider.primaryKey]) return;

    NSMutableDictionary *entityObjectsMap = self.fetchedExistingEntities[provider.entityName];
    entityObjectsMap[[object valueForKey:provider.primaryKey]] = object;
    self.fetchedExistingEntities[provider.entityName] = entityObjectsMap;
}

@end
