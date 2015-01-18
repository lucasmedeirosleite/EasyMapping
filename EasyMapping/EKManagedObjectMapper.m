//
//  EasyMapping
//
//  Copyright (c) 2012-2014 Lucas Medeiros.
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

#import "EKManagedObjectMapper.h"
#import "EKPropertyHelper.h"
#import "EKCoreDataImporter.h"
#import "EKRelationshipMapping.h"

@interface EKManagedObjectMapper ()
@property (nonatomic, strong) EKCoreDataImporter * importer;

+ (instancetype)mapperWithImporter:(EKCoreDataImporter *)importer;

@end

@implementation EKManagedObjectMapper

+ (instancetype)mapperWithImporter:(EKCoreDataImporter *)importer
{
    EKManagedObjectMapper * mapper = [self new];
    mapper.importer = importer;
    return mapper;
}

- (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                           withMapping:(EKManagedObjectMapping *)mapping
                       incrementalData:(BOOL)incrementalData
{
    NSManagedObject * object = [self.importer existingObjectForRepresentation:externalRepresentation
                                                                      mapping:mapping
                                                                      context:self.importer.context];
    if (!object)
    {
        object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName
                                               inManagedObjectContext:self.importer.context];
    }
    NSManagedObject * filledObject = [self fillObject:object
                           fromExternalRepresentation:externalRepresentation
                                          withMapping:mapping
                                      incrementalData:incrementalData];
    [self.importer cacheObject:filledObject withMapping:mapping];
    
    return filledObject;
}

- (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation
     withMapping:(EKManagedObjectMapping *)mapping
 incrementalData:(BOOL)incrementalData
{
    NSDictionary * representation = [EKPropertyHelper extractRootPathFromExternalRepresentation:externalRepresentation
                                                                                    withMapping:mapping];
    [mapping.propertyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop)
    {
        [EKPropertyHelper setProperty:obj
                             onObject:object
                   fromRepresentation:representation
                            inContext:self.importer.context];
    }];
    [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKRelationshipMapping * mapping, BOOL * stop)
    {
        NSDictionary * value = [mapping extractObjectFromRepresentation:representation];
        if (value && value != (id)[NSNull null])
        {
            id result = [self objectFromExternalRepresentation:value withMapping:(EKManagedObjectMapping *)[mapping objectMapping] incrementalData:incrementalData];
            [EKPropertyHelper setValue:result onObject:object forKeyPath:mapping.property];
        }
    }];
    [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKRelationshipMapping * mapping, BOOL * stop)
    {
        NSArray * arrayToBeParsed = [representation valueForKeyPath:key];
        if (arrayToBeParsed && arrayToBeParsed != (id)[NSNull null])
        {
            NSArray * parsedArray = [self arrayOfObjectsFromExternalRepresentation:arrayToBeParsed
                                                                       withMapping:(EKManagedObjectMapping *)[mapping objectMapping]
                                                                   incrementalData:incrementalData];
            id parsedObjects = [EKPropertyHelper propertyRepresentation:parsedArray
                                                              forObject:object
                                                       withPropertyName:[mapping property]];
            if(incrementalData) {
                [EKPropertyHelper addValue:parsedObjects onObject:object forKeyPath:mapping.property];
            }
            else {
                [EKPropertyHelper setValue:parsedObjects onObject:object forKeyPath:mapping.property];
            }
        }
    }];
    return object;
}

- (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKManagedObjectMapping *)mapping
                                      incrementalData:(BOOL)incrementalData
{

    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * representation in externalRepresentation)
    {
        id parsedObject = [self objectFromExternalRepresentation:representation withMapping:mapping incrementalData:incrementalData];
        [array addObject:parsedObject];
    }
    return [NSArray arrayWithArray:array];
}

- (NSArray *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                              withMapping:(EKManagedObjectMapping *)mapping
                                             fetchRequest:(NSFetchRequest *)fetchRequest
                                          incrementalData:(BOOL)incrementalData
{
    NSAssert(mapping.primaryKey, @"A mapping with a primary key is required");
    EKPropertyMapping * primaryKeyPropertyMapping = [mapping primaryKeyPropertyMapping];

    // Create a dictionary that maps primary keys to existing objects
    NSArray * existing = [self.importer.context executeFetchRequest:fetchRequest error:NULL];
    NSDictionary * existingByPK = [NSDictionary dictionaryWithObjects:existing
                                                              forKeys:[existing valueForKey:primaryKeyPropertyMapping.property]];

    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * representation in externalRepresentation)
    {
        // Look up the object by its primary key
        id primaryKeyValue = [EKPropertyHelper getValueOfManagedProperty:primaryKeyPropertyMapping
                                                      fromRepresentation:representation
                                                               inContext:self.importer.context];
        id object = [existingByPK objectForKey:primaryKeyValue];

        // Create a new object if necessary
        if (!object)
            object = [NSEntityDescription insertNewObjectForEntityForName:mapping.entityName
                                                   inManagedObjectContext:self.importer.context];

        [self fillObject:object fromExternalRepresentation:representation withMapping:mapping incrementalData:incrementalData];
        [array addObject:object];
    }

    // Any object returned by the fetch request not in the external represntation has to be deleted
    NSMutableSet * toDelete = [NSMutableSet setWithArray:existing];
    [toDelete minusSet:[NSSet setWithArray:array]];
    for (NSManagedObject * o in toDelete)
        [self.importer.context deleteObject:o];

    return [NSArray arrayWithArray:array];
}


#pragma mark - CoreData Importer
/*
 All methods below perform a redirection to instance methods, that use CoreData importer class
 */

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                           withMapping:(EKManagedObjectMapping *)mapping
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self objectFromExternalRepresentation:externalRepresentation
                                      withMapping:mapping
                           inManagedObjectContext:context
                                  incrementalData:NO];
}

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                           withMapping:(EKManagedObjectMapping *)mapping
                inManagedObjectContext:(NSManagedObjectContext *)context
                       incrementalData:(BOOL)incrementalData
{
    NSParameterAssert([mapping isKindOfClass:[EKManagedObjectMapping class]]);
    NSParameterAssert(context);
    
    EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:mapping
                                                     externalRepresentation:externalRepresentation
                                                                    context:context];
    return [[self mapperWithImporter:importer] objectFromExternalRepresentation:externalRepresentation
                                                                    withMapping:mapping
                                                                incrementalData:incrementalData];
}

+ (id)          fillObject:(id)object
fromExternalRepresentation:(NSDictionary *)externalRepresentation
               withMapping:(EKManagedObjectMapping *)mapping
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self fillObject:object
 fromExternalRepresentation:externalRepresentation
                withMapping:mapping
     inManagedObjectContext:context
            incrementalData:NO];
}

+ (id)            fillObject:(id)object
  fromExternalRepresentation:(NSDictionary *)externalRepresentation
                 withMapping:(EKManagedObjectMapping *)mapping
      inManagedObjectContext:(NSManagedObjectContext*)context
             incrementalData:(BOOL)incrementalData
{
    NSParameterAssert([mapping isKindOfClass:[EKManagedObjectMapping class]]);
    NSParameterAssert(context);
    
    EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:mapping
                                                     externalRepresentation:externalRepresentation
                                                                    context:context];
    return [[self mapperWithImporter:importer] fillObject:object
                               fromExternalRepresentation:externalRepresentation
                                              withMapping:mapping
                                          incrementalData:incrementalData];
}

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKManagedObjectMapping *)mapping
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self arrayOfObjectsFromExternalRepresentation:externalRepresentation
                                              withMapping:mapping
                                   inManagedObjectContext:context
                                         incrementalData:NO];
}

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKManagedObjectMapping *)mapping
                               inManagedObjectContext:(NSManagedObjectContext*)context
                                     incrementalData:(BOOL)incrementalData
{
    NSParameterAssert([mapping isKindOfClass:[EKManagedObjectMapping class]]);
    NSParameterAssert(context);
    
    EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:mapping
                                                     externalRepresentation:externalRepresentation
                                                                    context:context];

    return [[self mapperWithImporter:importer] arrayOfObjectsFromExternalRepresentation:externalRepresentation
                                                                            withMapping:mapping
                                                                        incrementalData:incrementalData];
}

+ (NSArray *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                              withMapping:(EKManagedObjectMapping *)mapping
                                             fetchRequest:(NSFetchRequest *)fetchRequest
                                   inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self syncArrayOfObjectsFromExternalRepresentation:externalRepresentation
                                                  withMapping:mapping
                                                 fetchRequest:fetchRequest
                                       inManagedObjectContext:context
                                              incrementalData:NO];
}

+ (NSArray *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                              withMapping:(EKManagedObjectMapping *)mapping
                                             fetchRequest:(NSFetchRequest *)fetchRequest
                                   inManagedObjectContext:(NSManagedObjectContext *)context
                                          incrementalData:(BOOL)incrementalData
{
    NSParameterAssert([mapping isKindOfClass:[EKManagedObjectMapping class]]);
    NSParameterAssert(context);
    
    EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:mapping
                                                     externalRepresentation:externalRepresentation
                                                                    context:context];
    return [[self mapperWithImporter:importer] syncArrayOfObjectsFromExternalRepresentation:externalRepresentation
                                                                                withMapping:mapping
                                                                               fetchRequest:fetchRequest
                                                                            incrementalData:incrementalData];
}

@end
