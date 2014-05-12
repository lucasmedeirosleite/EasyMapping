//
//  EKPropertyHelper.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 26/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

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

+ (void)setField:(EKFieldMapping *)fieldMapping onObject:(id)object fromRepresentation:(NSDictionary *)representation
{
    id value = [self getValueOfField:fieldMapping fromRepresentation:representation];
    if (value == (id)[NSNull null]) {
        if (![self propertyNameIsScalar:fieldMapping.field fromObject:object]) {
            [self setValue:nil onObject:object forKeyPath:fieldMapping.field];
        }
    } else if (value) {
        [self setValue:value onObject:object forKeyPath:fieldMapping.field];
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

+ (id)getValueOfField:(EKFieldMapping *)fieldMapping fromRepresentation:(NSDictionary *)representation
{
    id value;
    if (fieldMapping.valueBlock) {
        value = fieldMapping.valueBlock(fieldMapping.keyPath, [representation valueForKeyPath:fieldMapping.keyPath]);
    } else if (fieldMapping.dateFormat) {
        id tempValue = [representation valueForKeyPath:fieldMapping.keyPath];
        if ([tempValue isKindOfClass:[NSString class]]) {
            value = [EKTransformer transformString:tempValue withDateFormat:fieldMapping.dateFormat];
        } else {
            value = nil;
        }
    } else {
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
