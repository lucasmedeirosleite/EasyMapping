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
        _fieldMappings = [NSMutableDictionary dictionary];
        _hasOneMappings = [NSMutableDictionary dictionary];
        _hasManyMappings = [NSMutableDictionary dictionary];
		 _recursiveOneMapping = [NSMutableDictionary dictionary];
		 _recursiveManyMapping = [NSMutableDictionary dictionary];
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
   
	[mappingObj.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[self addFieldMappingToDictionary:obj];
	}];
	
	[mappingObj.hasOneMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		EKObjectMapping *mapping = obj;
		[self.hasOneMappings setObject:mapping forKey:mapping.keyPath];
	}];
   
	[mappingObj.hasManyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		EKObjectMapping *mapping = obj;
		[self.hasManyMappings setObject:mapping forKey:mapping.keyPath];
	}];

	[self.recursiveOneMapping addEntriesFromDictionary:mappingObj.recursiveOneMapping];
	[self.recursiveManyMapping addEntriesFromDictionary:mappingObj.recursiveManyMapping];
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

- (void)hasOneMapping:(EKObjectMapping *)mapping forKey:(NSString *)key
{
    mapping.field = key;
    mapping.keyPath = key;
    
    [self.hasOneMappings setObject:mapping forKey:mapping.keyPath];
}

-(void)hasOneMapping:(EKObjectMapping *)mapping forKey:(NSString *)key forField:(NSString *)field
{
    mapping.field = field;
    mapping.keyPath = key;
    
    [self.hasOneMappings setObject:mapping forKey:mapping.keyPath];
}

- (void)hasManyMapping:(EKObjectMapping *)mapping forKey:(NSString *)key
{
    mapping.field = key;
    mapping.keyPath = key;
    
    [self.hasManyMappings setObject:mapping forKey:mapping.keyPath];
}

-(void)hasManyMapping:(EKObjectMapping *)mapping forKey:(NSString *)key forField:(NSString *)field
{
    mapping.field = field;
    mapping.keyPath = key;
    
    [self.hasManyMappings setObject:mapping forKey:mapping.keyPath];
}

- (void)addFieldMappingToDictionary:(EKFieldMapping *)fieldMapping
{
    [self.fieldMappings setObject:fieldMapping forKey:fieldMapping.keyPath];
}

- (void)hasOneRecursiveMappingForKey:(NSString*)key forField:(NSString *)field
{
	[self.recursiveOneMapping setValue:field forKeyPath:key];
}

- (void)hasOneRecursiveMappingForKey:(NSString*)key
{
	[self hasOneRecursiveMappingForKey:key forField:key];
}

- (void)hasManyRecursiveMappingForKey:(NSString*)key forField:(NSString*)field
{
	[self.recursiveManyMapping setValue:field forKey:key];
}

- (void)hasManyRecursiveMappingForKey:(NSString*)key
{
	[self hasManyRecursiveMappingForKey:key forField:key];
}

@end
