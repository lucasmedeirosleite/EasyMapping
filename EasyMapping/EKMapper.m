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

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKObjectMapping *)mapping
{
    NSParameterAssert([mapping isKindOfClass:[EKObjectMapping class]]);
    
    if (![externalRepresentation isKindOfClass:[NSDictionary class]] ||
                ![mapping isKindOfClass:[EKObjectMapping class]])
    {
        return nil;
    }
    
    id object = [[mapping.objectClass alloc] init];
    return [self fillObject:object fromExternalRepresentation:externalRepresentation withMapping:mapping];
}

+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation
     withMapping:(EKObjectMapping *)mapping
{
    NSDictionary *representation = [EKPropertyHelper extractRootPathFromExternalRepresentation:externalRepresentation withMapping:mapping];
    [mapping.propertyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [EKPropertyHelper setProperty:obj
                             onObject:object
                   fromRepresentation:representation
                  respectPropertyType:mapping.respectPropertyFoundationTypes
                  ignoreMissingFields:mapping.ignoreMissingFields];
    }];
    for (EKRelationshipMapping *valueMapping in mapping.hasOneMappings) {
        if (valueMapping.condition) {
            if (!valueMapping.condition(representation)) {
                continue;
            }
        }
        
        NSDictionary * value = [valueMapping extractObjectFromRepresentation:representation];
        
        if(mapping.ignoreMissingFields  && !value)
        {
            continue;
        }
        
		 if (value && value != (id)[NSNull null]) {
			 id result = [self objectFromExternalRepresentation:value withMapping:[valueMapping mappingForRepresentation:value]];
			 [object setValue:result forKeyPath:valueMapping.property];
		 } else {
			 [object setValue:nil forKey:valueMapping.property];
		 }
    }
    
    for (EKRelationshipMapping *valueMapping in mapping.hasManyMappings) {

        if (valueMapping.condition) {
            if (!valueMapping.condition(representation)) {
                continue;
            }
        }
        
        NSArray *arrayToBeParsed = [representation valueForKeyPath:valueMapping.keyPath];
        if(mapping.ignoreMissingFields && !arrayToBeParsed)
        {
            continue;
        }
        
		 if (arrayToBeParsed && arrayToBeParsed != (id)[NSNull null]) {
			 NSArray *parsedArray = [self arrayOfObjectsFromExternalRepresentation:arrayToBeParsed
                                                                       withRelationship:valueMapping];
             id parsedObjects = [EKPropertyHelper propertyRepresentation:parsedArray
                                                               forObject:object
                                                        withPropertyName:[valueMapping property]];

             id _value = [object valueForKeyPath:valueMapping.property];
             
             if(mapping.incrementalData && _value!=nil) {
                 _value = [_value arrayByAddingObjectsFromArray:parsedObjects];
                 [object setValue:_value forKey:valueMapping.property];
             }
             else {
                 [object setValue:parsedObjects forKeyPath:valueMapping.property];
             }
		 } else if(!mapping.incrementalData) {
			 [object setValue:nil forKey:valueMapping.property];
		 }
    }
    return object;
}

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withRelationship:(EKRelationshipMapping *)mapping
{
    if (![externalRepresentation isKindOfClass:[NSArray class]] ||
        ![mapping isKindOfClass:[EKRelationshipMapping class]]) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        id parsedObject = [self objectFromExternalRepresentation:representation withMapping:[mapping mappingForRepresentation:representation]];
        if (parsedObject) {
            [array addObject:parsedObject];
        }
    }
    return [NSArray arrayWithArray:array];
}


+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKObjectMapping *)mapping
{
    if (![externalRepresentation isKindOfClass:[NSArray class]] ||
        ![mapping isKindOfClass:[EKObjectMapping class]]) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        id parsedObject = [self objectFromExternalRepresentation:representation withMapping:mapping];
        if (parsedObject) {
            [array addObject:parsedObject];
        }
    }
    return [NSArray arrayWithArray:array];
}

@end
