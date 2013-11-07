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

- (void)mapSubValuesOfKey:(NSString *)key toFieldsFromArray:(NSArray *)fieldsArray
{
    [fieldsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *field = obj;
        EKFieldMapping *mapping = [[EKFieldMapping alloc] init];
        mapping.field = field;
        mapping.keyPath = key;
        mapping.valueBlock = ^id(NSString *sameKey, id value) {
            return value[field];
        };
        [self addFieldMappingToDictionary:mapping];
    }];
}

- (void)mapSubValuesOfKey:(NSString *)key toFieldsFromDictionary:(NSDictionary *)fieldsDictionary
{
    [fieldsDictionary enumerateKeysAndObjectsUsingBlock:^(id subKey, id field, BOOL *stop) {
        EKFieldMapping *mapping = [[EKFieldMapping alloc] init];
        mapping.field = field;
        mapping.keyPath = key;
        mapping.valueBlock = ^id(NSString *sameKey, id value) {
            return value[subKey];
        };
        [self addFieldMappingToDictionary:mapping];
    }];
}

- (void)mapSubKey:(NSString *)subKey ofKey:(NSString *)key toField:(NSString *)field withDateFormat:(NSString *)dateFormat
{
    EKFieldMapping *mapping = [[EKFieldMapping alloc] init];
    mapping.field = field;
    mapping.keyPath = key;
    mapping.dateFormat = dateFormat;
    mapping.valueBlock = ^id(NSString *sameKey, id value) {
        NSString *stringDate = value[subKey];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = dateFormat;
        NSDate *date = [dateFormatter dateFromString:stringDate];

        return date;
    };
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
    [self.fieldMappings setObject:fieldMapping forKey:fieldMapping.field];
}

@end
