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
#import "EKFieldMapping.h"
#import "EKTransformer.h"
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

- (void)mapKey:(NSString *)key toField:(NSString *)field
{
    EKFieldMapping *fieldMapping = [[EKFieldMapping alloc] init];
    fieldMapping.field = field;
    fieldMapping.keyPath = key;
    [self addFieldMappingToDictionary:fieldMapping];
}

- (void)mapKey:(NSString *)key toField:(NSString *)field withDateFormat:(NSString *)dateFormat
{
    [self mapKey:key
         toField:field
  withValueBlock:^id(NSString * key, id value) {
        return [value isKindOfClass:[NSString class]] ? [EKTransformer transformString:value withDateFormat:dateFormat] : nil;;
    } withReverseBlock:^id(id value) {
        return [value isKindOfClass:[NSDate class]] ? [EKTransformer transformDate:value withDateFormat:dateFormat] : nil;
    }];
}

- (void)mapFieldsFromArray:(NSArray *)fieldsArray
{
    for (NSString *key in fieldsArray) {
        [self mapKey:key toField:key];
    }
}

-(void)mapFieldsFromArrayToPascalCase:(NSArray *)fieldsArray {
    
    for (NSString *key in fieldsArray) {
        NSString *pascalKey = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
        
        [self mapKey:pascalKey toField:key];
    }
}

- (void)mapFieldsFromDictionary:(NSDictionary *)fieldsDictionary
{
    [fieldsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self mapKey:key toField:obj];
    }];
}


-(void)mapFieldsFromMappingObject:(EKObjectMapping *)mappingObj {
    
    for (NSString *key in mappingObj.propertyMappings) {
        [self addFieldMappingToDictionary:mappingObj.propertyMappings[key]];
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

- (void)mapKey:(NSString *)key toField:(NSString *)field
withValueBlock:(id (^)(NSString *, id))valueBlock
{
    NSParameterAssert(valueBlock);
    EKFieldMapping *mapping = [[EKFieldMapping alloc] init];
    mapping.field = field;
    mapping.keyPath = key;
    mapping.valueBlock = valueBlock;
    [self addFieldMappingToDictionary:mapping];
}

- (void)mapKey:(NSString *)key toField:(NSString *)field
withValueBlock:(id (^)(NSString *, id))valueBlock withReverseBlock:(id (^)(id))reverseBlock
{
    NSParameterAssert(valueBlock);
    NSParameterAssert(reverseBlock);
    
    EKFieldMapping *mapping = [[EKFieldMapping alloc] init];
    mapping.field = field;
    mapping.keyPath = key;
    mapping.valueBlock = valueBlock;
    mapping.reverseBlock = reverseBlock;
    [self addFieldMappingToDictionary:mapping];
}

-(void)hasOne:(Class<EKMappingProtocol>)objectClass forKeyPath:(NSString *)keyPath
{
    [self hasOne:objectClass forKeyPath:keyPath forProperty:keyPath];
}

-(void)hasOne:(Class<EKMappingProtocol>)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property
{
    EKRelationshipMapping * relationship = [EKRelationshipMapping new];
    relationship.objectClass = objectClass;
    relationship.keyPath = keyPath;
    relationship.property = property;
    
    [self.hasOneMappings setObject:relationship forKey:keyPath];
}

-(void)hasMany:(Class<EKMappingProtocol>)objectClass forKeyPath:(NSString *)keyPath
{
    [self hasMany:objectClass forKeyPath:keyPath forProperty:keyPath];
}

-(void)hasMany:(Class<EKMappingProtocol>)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property
{
    EKRelationshipMapping * relationship = [EKRelationshipMapping new];
    relationship.keyPath = keyPath;
    relationship.property = property;
    relationship.objectClass = objectClass;
    
    [self.hasManyMappings setObject:relationship forKey:keyPath];
}

- (void)addFieldMappingToDictionary:(EKFieldMapping *)fieldMapping
{
    [self.propertyMappings setObject:fieldMapping forKey:fieldMapping.keyPath];
}

@end
