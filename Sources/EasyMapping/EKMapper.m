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

#import "EKMapper.h"
#import "EKPropertyHelper.h"
#import "EKPropertyMapping.h"
#import "EKRelationshipMapping.h"

@implementation EKMapper

-(instancetype)initWithMappingStore:(id<EKMappingStore>)store {
    self = [super init];
    if (self) {
        self.store = store;
    }
    return self;
}

- (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                           withMapping:(EKObjectMapping *)mapping
{
    [self.store startMappingForRepresentation:externalRepresentation withMapping:mapping];
    id object = [self _objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
    [self.store finishMapping];
    return object;
}

-(id)_objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                           withMapping:(EKObjectMapping *)mapping {
    if (![externalRepresentation isKindOfClass:NSDictionary.class]) { return nil; }
    id object = [self.store existingObjectForRepresentation:externalRepresentation
                                                withMapping:mapping];
    if (!object) {
        object = [mapping.contextProvider createNewEmptyObjectInStore:self.store];
    }
    [self fillObjectProperties:object
    fromExternalRepresentation:externalRepresentation
                   withMapping:mapping];
    [self.store cacheObject:object withMapping:mapping];
    [self fillObjectOneRelationships:object
          fromExternalRepresentation:externalRepresentation
                         withMapping:mapping];
    [self fillObjectManyRelationships:object
           fromExternalRepresentation:externalRepresentation
                          withMapping:mapping];
    
    return object;
}

-(id)fillObject:(id<EKMappingProtocol>)object fromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKObjectMapping *)mapping {
    [self.store startMappingForRepresentation:externalRepresentation withMapping:mapping];
    [self fillObjectProperties:object fromExternalRepresentation:externalRepresentation withMapping:mapping];
    [self fillObjectOneRelationships:object fromExternalRepresentation:externalRepresentation withMapping:mapping];
    [self fillObjectManyRelationships:object fromExternalRepresentation:externalRepresentation withMapping:mapping];
    [self.store finishMapping];
    return object;
}

- (void)fillObjectProperties:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation
                 withMapping:(EKObjectMapping *)mapping
{
    NSDictionary * representation = [EKPropertyHelper extractRootPathFromExternalRepresentation:externalRepresentation
                                                                                    withMapping:mapping];
    [mapping.propertyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop)
     {
         [EKPropertyHelper setProperty:obj
                              onObject:object
                    fromRepresentation:representation
                       contextProvider:mapping.contextProvider
                                 store:self.store
                   respectPropertyType:mapping.respectPropertyFoundationTypes
                   ignoreMissingFields:mapping.ignoreMissingFields];
     }];
}

- (void)fillObjectOneRelationships:(id)object
        fromExternalRepresentation:(NSDictionary *)externalRepresentation
                       withMapping:(EKObjectMapping *)mapping
{
    NSDictionary *representation = [EKPropertyHelper extractRootPathFromExternalRepresentation:externalRepresentation
                                                                                   withMapping:mapping];
    for (EKRelationshipMapping *relationship in mapping.hasOneMappings) {
        if (relationship.condition && !relationship.condition(representation)) {
            continue;
        }
        NSDictionary * value = [relationship extractObjectFromRepresentation:representation];
        if(mapping.ignoreMissingFields && !value)
        {
            continue;
        }
        if (value && value != (id)[NSNull null]) {
            id result = [self _objectFromExternalRepresentation:value withMapping:[relationship mappingForRepresentation:value]];
            [EKPropertyHelper setValue:result onObject:object forKeyPath:relationship.property];
        } else {
            [EKPropertyHelper setValue:nil onObject:object forKeyPath:relationship.property];
        }
        
    }
}

- (void)fillObjectManyRelationships:(id)object
         fromExternalRepresentation:(NSDictionary *)externalRepresentation
                        withMapping:(EKObjectMapping *)mapping
{
    NSDictionary *representation = [EKPropertyHelper extractRootPathFromExternalRepresentation:externalRepresentation
                                                                                   withMapping:mapping];
    for (EKRelationshipMapping *relationship in mapping.hasManyMappings) {
        if (relationship.condition && !relationship.condition(representation)) {
            continue;
        }
        NSArray * arrayToBeParsed = [representation valueForKeyPath:relationship.keyPath];
        if(mapping.ignoreMissingFields && !arrayToBeParsed)
        {
            continue;
        }
        
        if (arrayToBeParsed && arrayToBeParsed != (id)[NSNull null])
        {
            NSArray * parsedArray = [self arrayOfObjectsFromExternalRepresentation:arrayToBeParsed
                                                                  withRelationship:relationship];
            id parsedObjects = [EKPropertyHelper propertyRepresentation:parsedArray
                                                              forObject:object
                                                       withPropertyName:[relationship property]];
            if(mapping.incrementalData) {
                [EKPropertyHelper addValue:parsedObjects onObject:object forKeyPath:relationship.property];
            }
            else {
                [EKPropertyHelper setValue:parsedObjects onObject:object forKeyPath:relationship.property];
            }
        } else if (!mapping.incrementalData) {
            [EKPropertyHelper setValue:nil onObject:object forKeyPath:relationship.property];
        }
    }
}

- (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                     withRelationship:(EKRelationshipMapping *)mapping
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * representation in externalRepresentation)
    {
        id parsedObject = [self _objectFromExternalRepresentation:representation
                                                     withMapping:[mapping mappingForRepresentation:representation]];
        [array addObject:parsedObject];
    }
    return [NSArray arrayWithArray:array];
}

- (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKObjectMapping *)mapping
{
    [self.store startMappingForRepresentation:externalRepresentation withMapping:mapping];
    NSArray * objects = [self _arrayOfObjectsFromExternalRepresentation:externalRepresentation
                                                            withMapping:mapping];
    [self.store finishMapping];
    return objects;
}

- (NSArray *)_arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                           withMapping:(EKObjectMapping *)mapping {
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * representation in externalRepresentation)
    {
        id parsedObject = [self _objectFromExternalRepresentation:representation withMapping:mapping];
        if (parsedObject) {
            [array addObject:parsedObject];
        }
    }
    return [NSArray arrayWithArray:array];
}


+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKObjectMapping *)mapping
{
    EKObjectStore * store = [EKObjectStore new];
    EKMapper * mapper = [[EKMapper alloc] initWithMappingStore:store];
    return [mapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
}

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation
     withMapping:(EKObjectMapping *)mapping
{
    if (![externalRepresentation isKindOfClass:NSDictionary.class]) { return nil; }
    EKMapper * mapper = [[EKMapper alloc] initWithMappingStore:[EKObjectStore new]];
    return [mapper fillObject:object fromExternalRepresentation:externalRepresentation
                  withMapping:mapping];
}

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withRelationship:(EKRelationshipMapping *)mapping
{
    if (![externalRepresentation isKindOfClass:[NSArray class]] ||
        ![mapping isKindOfClass:[EKRelationshipMapping class]]) {
        return nil;
    }
    EKMapper * mapper = [[EKMapper alloc] initWithMappingStore:[EKObjectStore new]];
    return [mapper arrayOfObjectsFromExternalRepresentation:externalRepresentation withRelationship:mapping];
}


+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKObjectMapping *)mapping
{
    if (![externalRepresentation isKindOfClass:[NSArray class]] ||
        ![mapping isKindOfClass:[EKObjectMapping class]]) {
        return nil;
    }
    
    EKMapper * mapper = [[EKMapper alloc] initWithMappingStore:[EKObjectStore new]];
    return [mapper arrayOfObjectsFromExternalRepresentation:externalRepresentation withMapping:mapping];
}

@end
