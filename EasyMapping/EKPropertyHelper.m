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

#import "EKPropertyHelper.h"
#import <objc/runtime.h>
#import "EKTransformer.h"
#import <CoreData/CoreData.h>

static const char scalarTypes[] = {
    _C_BOOL, _C_BFLD,          // BOOL
    _C_CHR, _C_UCHR,           // char, unsigned char
    _C_SHT, _C_USHT,           // short, unsigned short
    _C_INT, _C_UINT,           // int, unsigned int, NSInteger, NSUInteger
    _C_LNG, _C_ULNG,           // long, unsigned long
    _C_LNG_LNG, _C_ULNG_LNG,   // long long, unsigned long long
    _C_FLT, _C_DBL             // float, CGFloat, double
};

@implementation EKPropertyHelper

#pragma mark - Property introspection

+ (BOOL)propertyNameIsScalar:(NSString *)propertyName fromObject:(id)object
{
    objc_property_t property = class_getProperty(object_getClass(object), [propertyName UTF8String]);
	NSString *type = property ? [self propertyTypeStringRepresentationFromProperty:property] : nil;
    
	return (type.length == 1) && (NSNotFound != [@(scalarTypes) rangeOfString:type].location);
}

+ (NSString *) propertyTypeStringRepresentationFromProperty:(objc_property_t)property
{
    const char *TypeAttribute = "T";
	char *type = property_copyAttributeValue(property, TypeAttribute);
	NSString *propertyType = (type[0] != _C_ID) ? @(type) : ({
		(type[1] == 0) ? @"id" : ({
			// Modern format of a type attribute (e.g. @"NSSet")
			type[strlen(type) - 1] = 0;
			@(type + 2);
		});
	});
	free(type);
	return propertyType;
}

+ (id)propertyRepresentation:(NSArray *)array forObject:(id)object withPropertyName:(NSString *)propertyName
{
    objc_property_t property = class_getProperty([object class], [propertyName UTF8String]);
	if (property)
    {
		NSString *type = [self propertyTypeStringRepresentationFromProperty:property];
		if ([type isEqualToString:@"NSSet"]) {
			return [NSSet setWithArray:array];
		}
		else if ([type isEqualToString:@"NSMutableSet"]) {
            return [NSMutableSet setWithArray:array];
		}
		else if ([type isEqualToString:@"NSOrderedSet"]) {
            return [NSOrderedSet orderedSetWithArray:array];
		}
		else if ([type isEqualToString:@"NSMutableOrderedSet"]) {
            return [NSMutableOrderedSet orderedSetWithArray:array];
		}
		else if ([type isEqualToString:@"NSMutableArray"]) {
            return [NSMutableArray arrayWithArray:array];
		}
	}
    return array;
}

#pragma mark Property accessor methods 

+ (void)setField:(EKPropertyMapping *)fieldMapping onObject:(id)object fromRepresentation:(NSDictionary *)representation
{
    id value = [self getValueOfField:fieldMapping fromRepresentation:representation];
    if (value == (id)[NSNull null]) {
        if (![self propertyNameIsScalar:fieldMapping.property fromObject:object]) {
            [self setValue:nil onObject:object forKeyPath:fieldMapping.property];
        }
    } else if (value) {
        [self setValue:value onObject:object forKeyPath:fieldMapping.property];
    }
}

+(void)setValue:(id)value onObject:(id)object forKeyPath:(NSString *)keyPath
{
    if ([(id <NSObject>)object isKindOfClass:[NSManagedObject class]])
    {
        // Reducing update times in CoreData
        id _value = [object valueForKeyPath:keyPath];
        
        if (_value != value && ![_value isEqual:value]) {
            [object setValue:value forKeyPath:keyPath];
        }
    }
    else {
        [object setValue:value forKeyPath:keyPath];
    }
}

+ (id)getValueOfField:(EKPropertyMapping *)fieldMapping fromRepresentation:(NSDictionary *)representation
{
    id value;
    if (fieldMapping.valueBlock) {
        id representationValue = [representation valueForKeyPath:fieldMapping.keyPath];
        value = fieldMapping.valueBlock(fieldMapping.keyPath, representationValue == [NSNull null] ? nil : representationValue);
    }
    else {
        value = [representation valueForKeyPath:fieldMapping.keyPath];
    }
    return value;
}

+ (NSDictionary *)extractRootPathFromExternalRepresentation:(NSDictionary *)externalRepresentation
                                                withMapping:(EKObjectMapping *)mapping
{
    if (mapping.rootPath) {
        return [externalRepresentation objectForKey:mapping.rootPath];
    }
    return externalRepresentation;
}
@end
