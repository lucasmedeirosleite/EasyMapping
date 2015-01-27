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
#import "EKDateTransformer.h"
#import "EKRelationshipMapping.h"
#import "EKMappingProtocol.h"

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
        _hasOneMappings = [NSMutableDictionary dictionary];
        _hasManyMappings = [NSMutableDictionary dictionary];
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

- (void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property withDateFormat:(NSString *)dateFormat
{
    NSParameterAssert(dateFormat);
    
    [self mapKeyPath:keyPath toProperty:property withDateTransform:^(EKDateTransformer *transformer) {
        transformer.dateFormatter.dateFormat = dateFormat;
    }];
}

- (void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property withDateTransform:(void (^)(EKDateTransformer *))dateTransformerSetupBlock
{
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    NSParameterAssert(dateTransformerSetupBlock);
    
    EKDateTransformer *transformer = [EKDateTransformer defaultDateTransformer];
    
    [self mapKeyPath:keyPath
          toProperty:property
      withValueBlock:^id(NSString * key, id value) {
          [transformer setupWithBlock:dateTransformerSetupBlock];
          return [value isKindOfClass:[NSString class]] ? [transformer transformedValue:value] : nil;
      } reverseBlock:^id(id value) {
          [transformer setupWithBlock:dateTransformerSetupBlock];
          return [value isKindOfClass:[NSDate class]] ? [transformer reverseTransformedValue:value] : nil;
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
    
    for (NSString *key in mappingObj.hasOneMappings) {
        EKRelationshipMapping *mapping = mappingObj.hasOneMappings[key];
        [self.hasOneMappings setObject:mapping forKey:mapping.keyPath];
    }
    
    for (NSString *key in mappingObj.hasManyMappings) {
         EKRelationshipMapping *mapping = mappingObj.hasManyMappings[key];
        [self.hasManyMappings setObject:mapping forKey:mapping.keyPath];
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

-(void)hasOne:(Class)objectClass forKeyPath:(NSString *)keyPath
{
    [self hasOne:objectClass forKeyPath:keyPath forProperty:keyPath withObjectMapping:nil];
}

-(void)hasOne:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property
{
    [self hasOne:objectClass forKeyPath:keyPath forProperty:property withObjectMapping:nil];
}

-(void)hasOne:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property withObjectMapping:(EKObjectMapping*)objectMapping
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
    relationship.objectMapping = objectMapping;
    
    [self.hasOneMappings setObject:relationship forKey:keyPath];
}

-(void)hasOne:(Class)objectClass forDictionaryFromKeyPaths:(NSArray *)keyPaths forProperty:(NSString *)property withObjectMapping:(EKObjectMapping *)mapping
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
    relationship.objectMapping = mapping;
    
    self.hasOneMappings[keyPaths.firstObject] = relationship;
}

-(void)hasMany:(Class)objectClass forKeyPath:(NSString *)keyPath
{
    [self hasMany:objectClass forKeyPath:keyPath forProperty:keyPath withObjectMapping:nil];
}

-(void)hasMany:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property
{
    [self hasMany:objectClass forKeyPath:keyPath forProperty:property withObjectMapping:nil];
}

-(void)hasMany:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property withObjectMapping:(EKObjectMapping*)objectMapping
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
    relationship.objectMapping = objectMapping;
    
    [self.hasManyMappings setObject:relationship forKey:keyPath];
}

- (void)addPropertyMappingToDictionary:(EKPropertyMapping *)propertyMapping
{
    [self.propertyMappings setObject:propertyMapping forKey:propertyMapping.keyPath];
}

@end
