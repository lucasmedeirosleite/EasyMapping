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
		 if (value && value != (id)[NSNull null]) {
			 id result = [self objectFromExternalRepresentation:value withMapping:valueMapping];
			 [object setValue:result forKeyPath:valueMapping.field];
		 } else {
			 [object setValue:nil forKey:valueMapping.field];
		 }
    }];
    [mapping.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        EKObjectMapping * valueMapping = obj;
		 NSArray *arrayToBeParsed = [representation valueForKeyPath:key];
		 if (arrayToBeParsed && arrayToBeParsed != (id)[NSNull null]) {
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
