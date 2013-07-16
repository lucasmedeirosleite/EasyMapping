//
//  EKPropertyHelper.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 26/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EKPropertyHelper.h"
#import <objc/runtime.h>

static const unichar nativeTypes[] = {
    _C_CHR, _C_UCHR,           // BOOL, char, unsigned char
    _C_SHT, _C_USHT,           // short, unsigned short
    _C_INT, _C_UINT,           // int, unsigned int, NSInteger, NSUInteger
    _C_LNG, _C_ULNG,           // long, unsigned long
    _C_LNG_LNG, _C_ULNG_LNG,   // long long, unsigned long long
    _C_FLT, _C_DBL             // float, CGFloat, double
};

static const char * getPropertyType(objc_property_t property);
static id getReturnValueFromInvocation(NSInvocation * invocation);


@implementation EKPropertyHelper


+ (id)performSelector:(SEL)selector onObject:(id)object
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [object performSelector:selector];
#pragma clang diagnostic pop
}

+ (id)performNativeSelector:(SEL)selector onObject:(id)object {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:object];
    [invocation invoke];
    return getReturnValueFromInvocation(invocation);
}

+ (BOOL)propertyNameIsNative:(NSString *)propertyName fromObject:(id)object
{
    NSString *typeDescription = [self getPropertyTypeFromObject:object withPropertyName:propertyName];
    
    if (typeDescription.length == 1) {
        unichar propertyType = [typeDescription characterAtIndex:0];
        for (int i = 0; i < sizeof(nativeTypes); i++) {
            if (nativeTypes[i] == propertyType) {
                return YES;
            }
        }
    }
    
    return NO;
}

+ (NSString *)getPropertyTypeFromObject:(id)object withPropertyName:(NSString *)propertyString
{
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for(unsigned int i = 0; i < outCount; i++) {
    	
        objc_property_t property = properties[i];
    	
        const char *propName = property_getName(property);
    	
        if(propName) {
    		NSString *propertyName = [[NSString alloc] initWithCString:propName encoding:NSUTF8StringEncoding];
            if ([propertyName isEqualToString:propertyString]) {
                return [[NSString alloc] initWithCString:getPropertyType(property) encoding:NSUTF8StringEncoding];
            }
    	}
    }
    return nil;
}

static const char * getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
//    printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

static id getReturnValueFromInvocation(NSInvocation * invocation) {
    NSValue * returnValue = nil;

    NSUInteger returnSize = [[invocation methodSignature] methodReturnLength];
    char const *returnType = [[invocation methodSignature] methodReturnType];

    if ( returnSize > 0 && strlen(returnType) == 1 ) {
        void *buffer = malloc(returnSize);
        [invocation getReturnValue:buffer];

        // For floating point numbers, use float or double
        if ( !strcmp(returnType, @encode(float)) ) {
            float floatValue = 0;
            memcpy(&floatValue, buffer, returnSize);
            returnValue = [NSNumber numberWithFloat:floatValue];
        } else if ( !strcmp(returnType, @encode(double)) ) {
            double doubleValue = 0;
            memcpy(&doubleValue, buffer, returnSize);
            returnValue = [NSNumber numberWithDouble:doubleValue];
        } else {
            // For other signed types use long long
            long long longValue = 0;
            memcpy(&longValue, buffer, returnSize);
            returnValue = [NSNumber numberWithLongLong:longValue];
        }

        free(buffer);
    }

    return returnValue;
}

@end


