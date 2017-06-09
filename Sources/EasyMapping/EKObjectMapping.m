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
#import "EKPropertyHelper.h"

@implementation EKObjectMapping

-(void)setObjectClass:(id)objectClass {
    self.contextProvider.objectClass = objectClass;
}

-(id)objectClass {
    return self.contextProvider.objectClass;
}

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
    return [self initWithContextProvider:[[EKMappingContextProvider alloc] initWithObjectClass:objectClass]];
}

-(instancetype)initWithContextProvider:(id <EKMappingContextProviding>)provider {
    self = [super init];
    
    _propertyMappings = [NSMutableDictionary dictionary];
    _hasOneMappings = [NSMutableArray array];
    _hasManyMappings = [NSMutableArray array];
    self.contextProvider = provider;
    return self;
}

-(instancetype)initWithContextProvider:(id <EKMappingContextProviding>)provider rootPath:(NSString *)rootPath {
    self = [self initWithContextProvider:provider];
    _rootPath = rootPath;
    return self;
}

- (EKPropertyMapping *)primaryKeyPropertyMapping
{
    __block EKPropertyMapping * primaryKeyMapping = nil;
    [self.propertyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop)
     {
         EKPropertyMapping * mapping = obj;
         if ([mapping.property isEqualToString:self.contextProvider.primaryKey])
         {
             primaryKeyMapping = mapping;
             *stop = YES;
         }
     }];
    return primaryKeyMapping;
}

- (id)initWithObjectClass:(Class)objectClass withRootPath:(NSString *)rootPath
{
    return [self initWithContextProvider:[[EKMappingContextProvider alloc] initWithObjectClass:objectClass]
                                rootPath:rootPath];
}

- (void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    
    EKPropertyMapping *mapping = [EKPropertyMapping mappingWithKeyPath:keyPath forProperty:property];
    [self addPropertyMappingToDictionary:mapping];
}

-(void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property withDateFormatter:(NSDateFormatter *)formatter
{
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    NSParameterAssert(formatter);
    
    [self mapKeyPath:keyPath
          toProperty:property
      withValueBlock:^id(EKMappingContext * context) {
          if (context.value == NSNull.null) return context.value;
          return [context.value isKindOfClass:[NSString class]] ? [formatter dateFromString:context.value] : nil;
      } reverseBlock:^id(EKMappingContext * context) {
          return [context.value isKindOfClass:[NSDate class]] ? [formatter stringFromDate:context.value] : nil;
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
withValueBlock:(EKMappingBlock)valueBlock
{
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    NSParameterAssert(valueBlock);
    
    EKPropertyMapping *mapping = [EKPropertyMapping mappingWithKeyPath:keyPath forProperty:property];
    mapping.valueBlock = valueBlock;
    [self addPropertyMappingToDictionary:mapping];
}

- (void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property
withValueBlock:(EKMappingBlock)valueBlock reverseBlock:(EKMappingBlock)reverseBlock
{
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    NSParameterAssert(valueBlock);
    NSParameterAssert(reverseBlock);
    
    EKPropertyMapping *mapping = [EKPropertyMapping mappingWithKeyPath:keyPath forProperty:property];
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
        NSParameterAssert([objectClass conformsToProtocol:@protocol(EKMappingProtocol)]);
    }
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    
    EKRelationshipMapping * relationship = [EKRelationshipMapping mappingForClass:objectClass
                                                                      withKeyPath:keyPath
                                                                      forProperty:property];
    relationship.mappingResolver = [self defaultMappingResolveBlockFor:objectClass
                                                                  with:objectMapping];
    relationship.serializationResolver = [self defaultSerializationResolveBlockFor:objectClass
                                                                              with:objectMapping];
    [self.hasOneMappings addObject:relationship];
    
    return relationship;
}

- (EKRelationshipMapping *)hasOne:(Class)objectClass forDictionaryFromKeyPaths:(NSArray *)keyPaths forProperty:(NSString *)property withObjectMapping:(EKObjectMapping *)mapping
{
    if (!mapping) {
        NSParameterAssert([objectClass conformsToProtocol:@protocol(EKMappingProtocol)]);
    }
    NSParameterAssert(keyPaths);
    NSParameterAssert(property);
    
    EKRelationshipMapping * relationship = [EKRelationshipMapping mappingForClass:objectClass
                                                                      withKeyPath:@""
                                                                      forProperty:property];
    relationship.nonNestedKeyPaths = keyPaths;
    relationship.mappingResolver = [self defaultMappingResolveBlockFor:objectClass
                                                                  with:mapping];
    relationship.serializationResolver = [self defaultSerializationResolveBlockFor:objectClass
                                                                              with:mapping];
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
        NSParameterAssert([objectClass conformsToProtocol:@protocol(EKMappingProtocol)]);
    }
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    
    EKRelationshipMapping * relationship = [EKRelationshipMapping mappingForClass:objectClass
                                                                      withKeyPath:keyPath
                                                                      forProperty:property];
    relationship.mappingResolver = [self defaultMappingResolveBlockFor:objectClass
                                                                  with:objectMapping];
    relationship.serializationResolver = [self defaultSerializationResolveBlockFor:objectClass
                                                                              with:objectMapping];
    [self.hasManyMappings addObject:relationship];
    
    return relationship;
}

- (void)addPropertyMappingToDictionary:(EKPropertyMapping *)propertyMapping
{
    [self.propertyMappings setObject:propertyMapping forKey:propertyMapping.keyPath];
}

-(EKMappingResolvingBlock)defaultMappingResolveBlockFor:(Class)objectClass with:(EKObjectMapping *) mapping {
    return ^(id representation ){
        if (mapping != nil) {
            return mapping;
        }
        return [objectClass objectMapping];
    };
}

-(EKSerializationResolvingBlock)defaultSerializationResolveBlockFor:(Class)objectClass with:(EKObjectMapping *)objectMapping {
    return ^(id object) {
        if (objectMapping != nil) {
            return objectMapping;
        }
        return [objectClass objectMapping];
    };
}

@end
