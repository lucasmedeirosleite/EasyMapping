//
//  EKMapper.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EKMapper.h"
#import "EKPropertyHelper.h"
#import "EKFieldMapping.h"
#import "EKTransformer.h"

@implementation EKMapper

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKObjectMapping *)mapping
{
    id object = [[mapping.objectClass alloc] init];
    return [self fillObject:object fromExternalRepresentation:externalRepresentation withMapping:mapping];
}

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation
     withMapping:(EKObjectMapping *)mapping
{
    NSDictionary *representation = [EKPropertyHelper extractRootPathFromExternalRepresentation:externalRepresentation withMapping:mapping];
    [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [EKPropertyHelper setField:obj
                          onObject:object
                fromRepresentation:representation];
    }];
    [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		 EKObjectMapping * valueMapping = obj;
		 NSDictionary* value = [representation valueForKeyPath:key];
		 if (value != (id)[NSNull null]) {
			 id result = [self objectFromExternalRepresentation:value withMapping:valueMapping];
			 [object setValue:result forKeyPath:valueMapping.field];
		 } else {
			 [object setValue:nil forKey:valueMapping.field];
		 }
    }];
    [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        EKObjectMapping * valueMapping = obj;
		 NSArray *arrayToBeParsed = [representation valueForKeyPath:key];
		 if (arrayToBeParsed != (id)[NSNull null]) {
			 NSArray *parsedArray = [self arrayOfObjectsFromExternalRepresentation:arrayToBeParsed withMapping:obj];
             id parsedObjects = [EKPropertyHelper propertyRepresentation:parsedArray
                                                               forObject:object
                                                        withPropertyName:[obj field]];
			 [object setValue:parsedObjects forKeyPath:valueMapping.field];
		 } else {
			 [object setValue:nil forKey:valueMapping.field];
		 }
    }];
    return object;
}

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKObjectMapping *)mapping
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        id parsedObject = [self objectFromExternalRepresentation:representation withMapping:mapping];
        [array addObject:parsedObject];
    }
    return [NSArray arrayWithArray:array];
}

@end
