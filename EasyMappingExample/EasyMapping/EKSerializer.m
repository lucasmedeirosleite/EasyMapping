//
//  EKSerializer.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EKSerializer.h"
#import "EKFieldMapping.h"
#import "EKPropertyHelper.h"

@implementation EKSerializer

+ (NSDictionary *)serializeObject:(id)object withMapping:(EKObjectMapping *)mapping
{
    NSMutableDictionary *representation = [NSMutableDictionary dictionary];

    [mapping.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKFieldMapping *fieldMapping, BOOL *stop) {
        [self setValueOnRepresentation:representation fromObject:object withFieldMapping:fieldMapping];
    }];
    [mapping.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKObjectMapping *objectMapping, BOOL *stop) {
        [self setHasOneMappingObjectOn:representation withPropertyName:key withObjectMapping:objectMapping fromObject:object];
    }];
    [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, EKObjectMapping *objectMapping, BOOL *stop) {
        [self setHasManyMappingObjectOn:representation withPropertyName:key withObjectMapping:objectMapping fromObject:object];
    }];
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

+ (void)setValueOnRepresentation:(NSMutableDictionary *)representation fromObject:(id)object withFieldMapping:(EKFieldMapping *)fieldMapping
{
    SEL selector = NSSelectorFromString(fieldMapping.field);
    if ([EKPropertyHelper propertyNameIsNative:fieldMapping.field fromObject:object]) {
    
        if (fieldMapping.reverseBlock) {
            int *returnedValue = [EKPropertyHelper performSelector:selector onObject:object];
            id reverseValue = fieldMapping.reverseBlock(@(*returnedValue));
            [representation setObject:reverseValue forKey:fieldMapping.field];
        }
        
    } else {
        
        id returnedValue = [EKPropertyHelper perfomSelector:selector onObject:object];
        if (returnedValue) {
            if (fieldMapping.reverseBlock) {
                id reverseValue = fieldMapping.reverseBlock(returnedValue);
                [representation setObject:reverseValue forKey:fieldMapping.field];
            } else {
                [representation setObject:returnedValue forKey:fieldMapping.field];
            }
        }
        
    }

}

+ (void)setHasOneMappingObjectOn:(NSMutableDictionary *)representation withPropertyName:(NSString *)propertyName withObjectMapping:(EKObjectMapping *)mapping fromObject:(id)object
{
    id hasOneObject = [EKPropertyHelper perfomSelector:NSSelectorFromString(propertyName) onObject:object];
    if (hasOneObject) {
        NSDictionary *hasOneRepresentation = [self serializeObject:hasOneObject withMapping:mapping];
        [representation setObject:hasOneRepresentation forKey:propertyName];
    }
}

+ (void)setHasManyMappingObjectOn:(NSMutableDictionary *)representation withPropertyName:(NSString *)propertyName withObjectMapping:(EKObjectMapping *)mapping fromObject:(id)object
{
    id hasManyObject = [EKPropertyHelper perfomSelector:NSSelectorFromString(propertyName) onObject:object];
    if (hasManyObject) {
        NSArray *hasManyRepresentation = [self serializeCollection:hasManyObject withMapping:mapping];
        [representation setObject:hasManyRepresentation forKey:propertyName];
    }
}


@end
