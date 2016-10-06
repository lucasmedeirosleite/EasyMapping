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

#import "EKSerializer.h"
#import "EKPropertyMapping.h"
#import "EKPropertyHelper.h"
#import "EKRelationshipMapping.h"

@implementation EKSerializer

+ (NSDictionary *)serializeObject:(id)object withMapping:(EKObjectMapping *)mapping
{
    NSMutableDictionary *representation = [NSMutableDictionary dictionary];

    [mapping.propertyMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKPropertyMapping *propertyMapping, BOOL *stop) {
        [self setValueOnRepresentation:representation fromObject:object withPropertyMapping:propertyMapping];
    }];
    
    for (EKRelationshipMapping *relationship in mapping.hasOneMappings) {
        id hasOneObject = [object valueForKey:relationship.property];
        
        if (hasOneObject) {
            NSDictionary *hasOneRepresentation = [self serializeObject:hasOneObject
                                                           withMapping:[relationship mappingForObject:hasOneObject]];
            
            if (relationship.nonNestedKeyPaths)
            {
                for (NSString * key in hasOneRepresentation.allKeys)
                {
                    representation[key]=hasOneRepresentation[key];
                }
            }
            else {
                [representation setObject:hasOneRepresentation forKey:relationship.keyPath];
            }
        }
    }
    
    for (EKRelationshipMapping *relationship in mapping.hasManyMappings) {

        id hasManyObject = [object valueForKey:relationship.property];
        if (hasManyObject) {
            NSArray *hasManyRepresentation = [self serializeCollection:hasManyObject
                                                           withMapping:[[relationship objectClass] objectMapping]];
            [representation setObject:hasManyRepresentation forKey:relationship.keyPath];
        }
    }
    
    if (mapping.rootPath.length > 0) {
        NSMutableDictionary *rootRepresentation = [NSMutableDictionary new];
        [self setValue:representation forKeyPath:mapping.rootPath inRepresentation:rootRepresentation];
        representation = rootRepresentation;
    }
    return representation;
}

+ (NSArray *)serializeCollection:(NSArray *)collection withMapping:(EKObjectMapping *)mapping
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id object in collection) {
        NSDictionary *objectRepresentation = [self serializeObject:object withMapping:mapping];
        [array addObject:objectRepresentation];
    }
    
    return [NSArray arrayWithArray:array];
}

+(NSDictionary *)serializeObject:(id)object withMapping:(EKManagedObjectMapping *)mapping fromContext:(NSManagedObjectContext *)context
{
    NSMutableDictionary *representation = [NSMutableDictionary dictionary];
    
    [mapping.propertyMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKPropertyMapping *propertyMapping, BOOL *stop) {
        [self setValueOnRepresentation:representation
                     fromManagedObject:object
                   withPropertyMapping:propertyMapping
                             inContext:context];
    }];
    
    for (EKRelationshipMapping *relationship in mapping.hasOneMappings) {
        
        id hasOneObject = [object valueForKey:relationship.property];
        
        if (hasOneObject) {
            NSDictionary *hasOneRepresentation = [self serializeObject:hasOneObject
                                                           withMapping:(EKManagedObjectMapping *)[[relationship objectClass] objectMapping]
                                                           fromContext:context];
            
            if (relationship.nonNestedKeyPaths)
            {
                for (NSString * key in hasOneRepresentation.allKeys)
                {
                    representation[key]=hasOneRepresentation[key];
                }
            }
            else {
                [representation setObject:hasOneRepresentation forKey:relationship.keyPath];
            }
        }
    }
    
    for (EKRelationshipMapping *relationship in mapping.hasManyMappings) {

        id hasManyObject = [object valueForKey:relationship.property];
        if (hasManyObject) {
            NSArray *hasManyRepresentation = [self serializeCollection:hasManyObject
                                                           withMapping:(EKManagedObjectMapping *)[[relationship objectClass] objectMapping]
                                                           fromContext:context];
            [representation setObject:hasManyRepresentation forKey:relationship.keyPath];
        }
    }
    
    if (mapping.rootPath.length > 0) {
        NSMutableDictionary *rootRepresentation = [NSMutableDictionary new];
        [self setValue:representation forKeyPath:mapping.rootPath inRepresentation:rootRepresentation];
        representation = rootRepresentation;
    }
    return representation;
}

+(NSArray *)serializeCollection:(NSArray *)collection withMapping:(EKManagedObjectMapping *)mapping fromContext:(NSManagedObjectContext *)context
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id object in collection) {
        NSDictionary *objectRepresentation = [self serializeObject:object withMapping:mapping fromContext:context];
        [array addObject:objectRepresentation];
    }
    
    return [NSArray arrayWithArray:array];
}

+(void)setValueOnRepresentation:(NSMutableDictionary *)representation fromManagedObject:(id)object
            withPropertyMapping:(EKPropertyMapping *)propertyMapping inContext:(NSManagedObjectContext *)context
{
    id returnedValue = [object valueForKeyPath:propertyMapping.property];

    if (returnedValue) {

        if (propertyMapping.managedReverseBlock) {
            returnedValue = propertyMapping.managedReverseBlock(returnedValue,context);
        }
        [self setValue:returnedValue forKeyPath:propertyMapping.keyPath inRepresentation:representation];
    }
}

+ (void)setValueOnRepresentation:(NSMutableDictionary *)representation fromObject:(id)object withPropertyMapping:(EKPropertyMapping *)propertyMapping
{
    id returnedValue = [object valueForKeyPath:propertyMapping.property];
    
    if (returnedValue) {
        
        if (propertyMapping.reverseBlock) {
            returnedValue = propertyMapping.reverseBlock(returnedValue);
        }
        [self setValue:returnedValue forKeyPath:propertyMapping.keyPath inRepresentation:representation];
    }
}

+ (void)setValue:(id)value forKeyPath:(NSString *)keyPath inRepresentation:(NSMutableDictionary *)representation {
    NSArray *keyPathComponents = [keyPath componentsSeparatedByString:@"."];
    if ([keyPathComponents count] == 1) {
        [representation setObject:value forKey:keyPath];
    } else if ([keyPathComponents count] > 1) {
        NSString *attributeKey = [keyPathComponents lastObject];
        NSMutableArray *subPaths = [NSMutableArray arrayWithArray:keyPathComponents];
        [subPaths removeLastObject];
        
        id currentPath = representation;
        for (NSString *key in subPaths) {
            id subPath = [currentPath valueForKey:key];
            if (subPath == nil) {
                subPath = [NSMutableDictionary new];
                [currentPath setValue:subPath forKey:key];
            }
            currentPath = subPath;
        }
        [currentPath setValue:value forKey:attributeKey];
    }
}


@end
