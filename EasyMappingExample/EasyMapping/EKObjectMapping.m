//
//  EKObjectMapping.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EKObjectMapping.h"
#import "EKFieldMapping.h"

@implementation EKObjectMapping

+ (EKObjectMapping *)mappingForClass:(Class)objectClass withBlock:(void (^)(EKObjectMapping *))mappingBlock
{
    EKObjectMapping *mapping = [[EKObjectMapping alloc] initWithObjectClass:objectClass];
    mappingBlock(mapping);
    return mapping;
}

+ (EKObjectMapping *)mappingForClass:(Class)objectClass withRootPath:(NSString *)rootPath withBlock:(void (^)(EKObjectMapping *))mappingBlock
{
    EKObjectMapping *mapping = [[EKObjectMapping alloc] initWithObjectClass:objectClass withRootPath:rootPath];
    mappingBlock(mapping);
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
    EKFieldMapping *fieldMapping = [[EKFieldMapping alloc] init];
    fieldMapping.field = field;
    fieldMapping.keyPath = key;
    fieldMapping.dateFormat = dateFormat;
    [self addFieldMappingToDictionary:fieldMapping];
}

- (void)mapFieldsFromArray:(NSArray *)fieldsArray
{
    for (NSString *key in fieldsArray) {
        [self mapKey:key toField:key];
    }
}

- (void)mapFieldsFromDictionary:(NSDictionary *)fieldsDictionary
{
    [fieldsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self mapKey:key toField:obj];
    }];
}

- (void)mapKey:(NSString *)key toField:(NSString *)field
withValueBlock:(id (^)(NSString *, id))valueBlock
{
    EKFieldMapping *mapping = [[EKFieldMapping alloc] init];
    mapping.field = field;
    mapping.keyPath = key;
    mapping.valueBlock = valueBlock;
    [self addFieldMappingToDictionary:mapping];
}

- (void)mapKey:(NSString *)key toField:(NSString *)field
withValueBlock:(id (^)(NSString *, id))valueBlock withReverseBlock:(id (^)(id))reverseBlock
{
    EKFieldMapping *mapping = [[EKFieldMapping alloc] init];
    mapping.field = field;
    mapping.keyPath = key;
    mapping.valueBlock = valueBlock;
    mapping.reverseBlock = reverseBlock;
    [self addFieldMappingToDictionary:mapping];
}

- (void)hasOneMapping:(EKObjectMapping *)mapping forKey:(NSString *)key
{
    [self.hasOneMappings setObject:mapping forKey:key];
}

- (void)hasManyMapping:(EKObjectMapping *)mapping forKey:(NSString *)key
{
    [self.hasManyMappings setObject:mapping forKey:key];
}

- (void)addFieldMappingToDictionary:(EKFieldMapping *)fieldMapping
{
    [self.fieldMappings setObject:fieldMapping forKey:fieldMapping.field];
}

@end
