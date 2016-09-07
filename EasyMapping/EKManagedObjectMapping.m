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

#import "EKManagedObjectMapping.h"

@implementation EKManagedObjectMapping

@synthesize propertyMappings = _propertyMappings;
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
        _propertyMappings = [NSMutableDictionary dictionary];
        _hasOneMappings = [NSMutableArray array];
        _hasManyMappings = [NSMutableArray array];
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

- (EKPropertyMapping *)primaryKeyPropertyMapping
{
    __block EKPropertyMapping * primaryKeyMapping = nil;
    [self.propertyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop)
    {
        EKPropertyMapping * mapping = obj;
        if ([mapping.property isEqualToString:self.primaryKey])
        {
            primaryKeyMapping = mapping;
            *stop = YES;
        }
    }];
    return primaryKeyMapping;
}

-(void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property withValueBlock:(EKManagedMappingValueBlock)valueBlock
{
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    NSParameterAssert(valueBlock);
    
    EKPropertyMapping *mapping = [[EKPropertyMapping alloc] init];
    mapping.property = property;
    mapping.keyPath = keyPath;
    mapping.managedValueBlock = valueBlock;
    [self addPropertyMappingToDictionary:mapping];
}

-(void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property withValueBlock:(EKManagedMappingValueBlock)valueBlock reverseBlock:(EKManagedMappingReverseValueBlock)reverseBlock
{
    NSParameterAssert(keyPath);
    NSParameterAssert(property);
    NSParameterAssert(valueBlock);
    NSParameterAssert(reverseBlock);
    
    EKPropertyMapping *mapping = [[EKPropertyMapping alloc] init];
    mapping.property = property;
    mapping.keyPath = keyPath;
    mapping.managedValueBlock = valueBlock;
    mapping.managedReverseBlock = reverseBlock;
    [self addPropertyMappingToDictionary:mapping];
}

- (void)addPropertyMappingToDictionary:(EKPropertyMapping *)mapping
{
    [self.propertyMappings setObject:mapping forKey:mapping.keyPath];
}

@end
