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
