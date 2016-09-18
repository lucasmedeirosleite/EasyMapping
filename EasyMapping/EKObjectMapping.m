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

#import "EKObjectMapping.h"
#import "EKPropertyMapping.h"
#import "EKRelationshipMapping.h"
#import "EKMappingProtocol.h"
#import "NSDateFormatter+EasyMappingAdditions.h"
#import "EKpropertyHelper.h"

@implementation EKObjectMapping

+ (EKObjectMapping *)mappingForClass:(Class)objectClass withBlock:(void (^)(EKObjectMapping *))mappingBlock
{
    EKObjectMapping *mapping = [[EKObjectMapping alloc] initWithObjectClass:objectClass];
    if (mappingBlock)
    {
        mappingBlock(mapping);
    }
    return mapping;
}

+ (EKObjectMapping *)mappingForClass:(Class)objectClass withRootPath:(NSString *)rootPath withBlock:(void (^)(EKObjectMapping *))mappingBlock
{
    EKObjectMapping *mapping = [[EKObjectMapping alloc] initWithObjectClass:objectClass withRootPath:rootPath];
    if (mappingBlock)
    {
       mappingBlock(mapping);
    }
    return mapping;
}

- (id)initWithObjectClass:(Class)objectClass
{
    self = [super init];
    if (self) {
        _objectClass = objectClass;
        _propertyMappings = [NSMutableDictionary dictionary];
        _hasOneMappings = [NSMutableArray array];
        _hasManyMappings = [NSMutableArray array];
    }
    return self;
}

- (id)initWithObjectClass:(Class)objectClass withRootPath:(NSString *)rootPath
{
    self = [self initWithObjectClass:objectClass];
    if (self) {
        _rootPath = rootPath;
    }
    return self;
}

- (void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    
    EKPropertyMapping *mapping = [[EKPropertyMapping alloc] init];
    mapping.property = property;
    mapping.keyPath = keyPath;
    [self addPropertyMappingToDictionary:mapping];
}

-(void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property withDateFormatter:(NSDateFormatter *)formatter
{
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    NSParameterAssert(formatter);
    
    [self mapKeyPath:keyPath
          toProperty:property
      withValueBlock:^id(NSString * key, id value) {
          if (value == nil)
              return nil;
          return [value isKindOfClass:[NSString class]] ? [formatter dateFromString:value] : [NSNull null];
      } reverseBlock:^id(id value) {
          if (value == nil)
              return nil;
          return [value isKindOfClass:[NSDate class]] ? [formatter stringFromDate:value] : [NSNull null];
      }];
}

- (void)mapPropertiesFromArray:(NSArray *)propertyNamesArray
{
    NSParameterAssert([propertyNamesArray isKindOfClass:[NSArray class]]);
    
    for (NSString *key in propertyNamesArray) {
        [self mapKeyPath:key toProperty:key];
    }
}

-(void)mapPropertiesFromArrayToPascalCase:(NSArray *)propertyNamesArray
{
    NSParameterAssert([propertyNamesArray isKindOfClass:[NSArray class]]);
    for (NSString *key in propertyNamesArray) {
        NSString *pascalKey = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
        
        [self mapKeyPath:pascalKey toProperty:key];
    }
}

- (void)mapPropertiesFromUnderscoreToCamelCase:(NSArray *)propertyNamesArray
{
    for (NSString *key in propertyNamesArray) {
        NSString *convertedKey = [EKPropertyHelper convertStringFromUnderScoreToCamelCase: key];
        
        [self mapKeyPath:key toProperty:convertedKey];
    }
}

- (void)mapPropertiesFromDictionary:(NSDictionary *)propertyDictionary
{
    NSParameterAssert([propertyDictionary isKindOfClass:[NSDictionary class]]);
    
    [propertyDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self mapKeyPath:key toProperty:obj];
    }];
}

-(void)mapPropertiesFromMappingObject:(EKObjectMapping *)mappingObj
{
    NSParameterAssert([mappingObj isKindOfClass:EKObjectMapping.class]);
    
    for (NSString *key in mappingObj.propertyMappings) {
        [self addPropertyMappingToDictionary:mappingObj.propertyMappings[key]];
    }
    
    for (EKRelationshipMapping *relationship in mappingObj.hasOneMappings) {
        [self.hasOneMappings addObject:relationship];
    }
    
    for (EKRelationshipMapping *relationship in mappingObj.hasManyMappings) {
        [self.hasManyMappings addObject:relationship];
    }
}

- (void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property
withValueBlock:(id (^)(NSString *, id))valueBlock
{
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    NSParameterAssert(valueBlock);
    
    EKPropertyMapping *mapping = [[EKPropertyMapping alloc] init];
    mapping.property = property;
    mapping.keyPath = keyPath;
    mapping.valueBlock = valueBlock;
    [self addPropertyMappingToDictionary:mapping];
}

- (void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property
withValueBlock:(id (^)(NSString *, id))valueBlock reverseBlock:(id (^)(id))reverseBlock
{
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    NSParameterAssert(valueBlock);
    NSParameterAssert(reverseBlock);
    
    EKPropertyMapping *mapping = [[EKPropertyMapping alloc] init];
    mapping.property = property;
    mapping.keyPath = keyPath;
    mapping.valueBlock = valueBlock;
    mapping.reverseBlock = reverseBlock;
    [self addPropertyMappingToDictionary:mapping];
}

- (EKRelationshipMapping *)hasOne:(Class)objectClass forKeyPath:(NSString *)keyPath
{
    return [self hasOne:objectClass forKeyPath:keyPath forProperty:keyPath withObjectMapping:nil];
}

- (EKRelationshipMapping *)hasOne:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property
{
    return [self hasOne:objectClass forKeyPath:keyPath forProperty:property withObjectMapping:nil];
}

- (EKRelationshipMapping *)hasOne:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property withObjectMapping:(EKObjectMapping*)objectMapping
{
    if (!objectMapping) {
        NSParameterAssert([objectClass conformsToProtocol:@protocol(EKMappingProtocol)] ||
                          [objectClass conformsToProtocol:@protocol(EKManagedMappingProtocol)]);
    }
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    
    EKRelationshipMapping * relationship = [EKRelationshipMapping new];
    relationship.objectClass = objectClass;
    relationship.keyPath = keyPath;
    relationship.property = property;
    relationship.mappingResolver = ^(id representation ){
        if (objectMapping != nil) {
            return objectMapping;
        }
        return [objectClass objectMapping];
    };
    relationship.serializationResolver = ^(id object) {
        if (objectMapping != nil) {
            return objectMapping;
        }
        return [objectClass objectMapping];
    };
    
    [self.hasOneMappings addObject:relationship];
    
    return relationship;
}

- (EKRelationshipMapping *)hasOne:(Class)objectClass forDictionaryFromKeyPaths:(NSArray *)keyPaths forProperty:(NSString *)property withObjectMapping:(EKObjectMapping *)mapping
{
    if (!mapping) {
        NSParameterAssert([objectClass conformsToProtocol:@protocol(EKMappingProtocol)] ||
                          [objectClass conformsToProtocol:@protocol(EKManagedMappingProtocol)]);
    }
    NSParameterAssert(keyPaths);
    NSParameterAssert(property);
    
    EKRelationshipMapping * relationship = [EKRelationshipMapping new];
    relationship.objectClass = objectClass;
    relationship.nonNestedKeyPaths = keyPaths;
    relationship.property = property;
    relationship.mappingResolver = ^(id representation ){
        if (mapping != nil) {
            return mapping;
        }
        return [objectClass objectMapping];
    };
    
    relationship.serializationResolver = ^(id object) {
        if (mapping != nil) {
            return mapping;
        }
        return [objectClass objectMapping];
    };
    
    [self.hasOneMappings addObject:relationship];
    
    return relationship;
}

- (EKRelationshipMapping *)hasMany:(Class)objectClass forKeyPath:(NSString *)keyPath
{
    return [self hasMany:objectClass forKeyPath:keyPath forProperty:keyPath withObjectMapping:nil];
}

- (EKRelationshipMapping *)hasMany:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property
{
    return [self hasMany:objectClass forKeyPath:keyPath forProperty:property withObjectMapping:nil];
}

- (EKRelationshipMapping *)hasMany:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property withObjectMapping:(EKObjectMapping*)objectMapping
{
    if (!objectMapping) {
        NSParameterAssert([objectClass conformsToProtocol:@protocol(EKMappingProtocol)] ||
                          [objectClass conformsToProtocol:@protocol(EKManagedMappingProtocol)]);
    }
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    
    EKRelationshipMapping * relationship = [EKRelationshipMapping new];
    relationship.objectClass = objectClass;
    relationship.keyPath = keyPath;
    relationship.property = property;
    relationship.mappingResolver = ^(id representation ){
        if (objectMapping != nil) {
            return objectMapping;
        }
        return [objectClass objectMapping];
    };
    relationship.serializationResolver = ^(id object) {
        if (objectMapping != nil) {
            return objectMapping;
        }
        return [objectClass objectMapping];
    };
    
    [self.hasManyMappings addObject:relationship];
    
    return relationship;
}

- (void)addPropertyMappingToDictionary:(EKPropertyMapping *)propertyMapping
{
    [self.propertyMappings setObject:propertyMapping forKey:propertyMapping.keyPath];
}

@end
