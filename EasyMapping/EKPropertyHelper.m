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
@import ObjectiveC.runtime;

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

+ (id)propertyRepresentation:(id)value forObject:(id)object withPropertyName:(NSString *)propertyName
{
    if  (!value)
    {
        return nil;
    }
    
    objc_property_t property = class_getProperty([object class], [propertyName UTF8String]);
	if (property)
    {
		NSString *type = [self propertyTypeStringRepresentationFromProperty:property];
		if ([type isEqualToString:@"NSSet"]) {
			return [NSSet setWithArray:value];
		}
		else if ([type isEqualToString:@"NSMutableSet"]) {
            return [NSMutableSet setWithArray:value];
		}
		else if ([type isEqualToString:@"NSOrderedSet"]) {
            return [NSOrderedSet orderedSetWithArray:value];
		}
		else if ([type isEqualToString:@"NSMutableOrderedSet"]) {
            return [NSMutableOrderedSet orderedSetWithArray:value];
		}
		else if ([type isEqualToString:@"NSMutableArray"]) {
            return [NSMutableArray arrayWithArray:value];
        } else if ([type isEqualToString:@"NSMutableDictionary"]) {
            return [NSMutableDictionary dictionaryWithDictionary:value];
        } 
	}
    return value;
}

#pragma mark Property accessor methods 

+ (void)setProperty:(EKPropertyMapping *)propertyMapping onObject:(id)object
 fromRepresentation:(NSDictionary *)representation respectPropertyType:(BOOL)respectPropertyType ignoreMissingFields:(BOOL)ignoreMIssingFields
{
    id value = [self getValueOfProperty:propertyMapping fromRepresentation:representation ignoreMissingFields:ignoreMIssingFields];
    if (value == (id)[NSNull null]) {
        if (![self propertyNameIsScalar:propertyMapping.property fromObject:object]) {
            [self setValue:nil onObject:object forKeyPath:propertyMapping.property];
        }
    } else if (value) {
        if (respectPropertyType) {
            value = [self propertyRepresentation:value
                                       forObject:object
                                withPropertyName:propertyMapping.property];
        }
        [self setValue:value onObject:object forKeyPath:propertyMapping.property];
    }
}

+ (void) setProperty:(EKPropertyMapping *)propertyMapping
            onObject:(id)object
  fromRepresentation:(NSDictionary *)representation
           inContext:(NSManagedObjectContext *)context
 respectPropertyType:(BOOL)respectPropertyType
ignoreMissingFields:(BOOL)ignoreMissingFields
{
    id value = [self getValueOfManagedProperty:propertyMapping
                            fromRepresentation:representation
                                     inContext:context];
    if (value == (id)[NSNull null]) {
        if (![self propertyNameIsScalar:propertyMapping.property fromObject:object]) {
            [self setValue:nil onObject:object forKeyPath:propertyMapping.property];
        }
    } else if (value) {
        if (respectPropertyType) {
            value = [self propertyRepresentation:value
                                       forObject:object
                                withPropertyName:propertyMapping.property];
        }
        [self setValue:value onObject:object forKeyPath:propertyMapping.property];
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

+(void)addValue:(id)value onObject:(id)object forKeyPath:(NSString *)keyPath
{
    id _value = [object valueForKeyPath:keyPath];
    if(![_value isKindOfClass:[NSSet class]]) {
        [self setValue:value onObject:object forKeyPath:keyPath];
    }
    else {
        if ([object isKindOfClass:[NSManagedObject class]])
        {
            // Reducing update times in CoreData
            if(_value != value && ![value isSubsetOfSet:_value]) {
                _value = [_value setByAddingObjectsFromSet:value];
                [object setValue:_value forKey:keyPath];
            }
        }
        else {
            _value = [_value setByAddingObjectsFromSet:value];
            [object setValue:_value forKey:keyPath];
        }
    }
}

+ (id)getValueOfProperty:(EKPropertyMapping *)propertyMapping fromRepresentation:(NSDictionary *)representation ignoreMissingFields:(BOOL)ignoreMissingFields
{
    if (propertyMapping == nil) return nil;
    id value = nil;
    
    if (propertyMapping.valueBlock) {
        value = [representation valueForKeyPath:propertyMapping.keyPath];
        if (value != nil || !ignoreMissingFields) {
            value = propertyMapping.valueBlock(propertyMapping.keyPath, value);
        }
    }
    else {
        value = [representation valueForKeyPath:propertyMapping.keyPath];
    }
    
    return value;
}

+(id)getValueOfManagedProperty:(EKPropertyMapping *)mapping
            fromRepresentation:(NSDictionary *)representation
                     inContext:(NSManagedObjectContext *)context
{
    if (mapping == nil) return nil;
    id value = nil;
    
    if (mapping.managedValueBlock) {
        id representationValue = [representation valueForKeyPath:mapping.keyPath];
        value = mapping.managedValueBlock(mapping.keyPath,representationValue,context);
    }
    else {
        value = [representation valueForKeyPath:mapping.keyPath];
    }
    
    return value;
}

+ (NSDictionary *)extractRootPathFromExternalRepresentation:(NSDictionary *)externalRepresentation
                                                withMapping:(EKObjectMapping *)mapping
{
    if (mapping.rootPath) {
        return [externalRepresentation valueForKeyPath:mapping.rootPath];
    }
    return externalRepresentation;
}

+ (NSString *)convertStringFromUnderScoreToCamelCase:(NSString *)string {
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0; idx < [string length]; idx += 1) {
        unichar c = [string characterAtIndex:idx];
        if (c == '_') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}
@end
