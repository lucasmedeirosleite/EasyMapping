//
//  EKManagedObjectMapping.m
//  EasyMappingExample
//
//  Created by Alejandro Isaza on 2013-03-13.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import "EKManagedObjectMapping.h"
#import "EKFieldMapping.h"

@implementation EKManagedObjectMapping

+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName withBlock:(void(^)(EKManagedObjectMapping *mapping))mappingBlock
{
    EKManagedObjectMapping *mapping = [[EKManagedObjectMapping alloc] initWithEntityName:entityName];
    mappingBlock(mapping);
    return mapping;
}

+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName withRootPath:(NSString *)rootPath withBlock:(void (^)(EKManagedObjectMapping *mapping))mappingBlock
{
    EKManagedObjectMapping *mapping = [[EKManagedObjectMapping alloc] initWithEntityName:entityName withRootPath:rootPath];
    mappingBlock(mapping);
    return mapping;
}

- (id)initWithEntityName:(NSString *)entityName
{
    self = [super init];
    if (self) {
        _entityName = entityName;
        _fieldMappings = [NSMutableDictionary dictionary];
        _hasOneMappings = [NSMutableDictionary dictionary];
        _hasManyMappings = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithEntityName:(NSString *)entityName withRootPath:(NSString *)rootPath
{
    self = [self initWithEntityName:entityName];
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

- (void)hasOneMapping:(EKManagedObjectMapping *)mapping forKey:(NSString *)key
{
    [self.hasOneMappings setObject:mapping forKey:key];
}

- (void)hasManyMapping:(EKManagedObjectMapping *)mapping forKey:(NSString *)key
{
    [self.hasManyMappings setObject:mapping forKey:key];
}

- (void)addFieldMappingToDictionary:(EKFieldMapping *)fieldMapping
{
    [self.fieldMappings setObject:fieldMapping forKey:fieldMapping.field];
}

@end
