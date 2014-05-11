//
//  EKManagedObjectMapping.m
//  EasyMappingExample
//
//  Created by Alejandro Isaza on 2013-03-13.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import "EKManagedObjectMapping.h"

@implementation EKManagedObjectMapping

@synthesize fieldMappings = _fieldMappings;
@synthesize hasManyMappings = _hasManyMappings;
@synthesize hasOneMappings = _hasOneMappings;
@synthesize rootPath = _rootPath;

+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName withBlock:(void (^)(EKManagedObjectMapping * mapping))mappingBlock
{
    EKManagedObjectMapping * mapping = [[EKManagedObjectMapping alloc] initWithEntityName:entityName];
    if (mappingBlock)
    {
        mappingBlock(mapping);
    }
    return mapping;
}

+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName withRootPath:(NSString *)rootPath withBlock:(void (^)(EKManagedObjectMapping * mapping))mappingBlock
{
    EKManagedObjectMapping * mapping = [[EKManagedObjectMapping alloc] initWithEntityName:entityName withRootPath:rootPath];
    if (mappingBlock)
    {
        mappingBlock(mapping);
    }
    return mapping;
}

- (id)initWithEntityName:(NSString *)entityName
{
    self = [super init];
    if (self)
    {
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
    if (self)
    {
        _rootPath = rootPath;
    }
    return self;
}

- (EKFieldMapping *)primaryKeyFieldMapping
{
    __block EKFieldMapping * primaryKeyMapping = nil;
    [self.fieldMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop)
    {
        EKFieldMapping * fieldMapping = obj;
        if ([fieldMapping.field isEqualToString:self.primaryKey])
        {
            primaryKeyMapping = fieldMapping;
            *stop = YES;
        }
    }];
    return primaryKeyMapping;
}

@end
