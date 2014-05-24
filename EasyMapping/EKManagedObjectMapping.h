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

#import "EKMappingBlocks.h"
#import "EKObjectMapping.h"
#import "EKFieldMapping.h"

#define EKDesignatedInitializer(__SEL__) __attribute__((unavailable("Invoke the designated initializer `" # __SEL__ "` instead.")))

@interface EKManagedObjectMapping : EKObjectMapping

@property (nonatomic, strong, readonly) NSString* entityName;
@property (nonatomic, strong) NSString *primaryKey;

+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                       withBlock:(void(^)(EKManagedObjectMapping *mapping))mappingBlock;
+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                    withRootPath:(NSString *)rootPath
                                       withBlock:(void (^)(EKManagedObjectMapping *mapping))mappingBlock;

- (instancetype)initWithEntityName:(NSString *)entityName;
- (instancetype)initWithEntityName:(NSString *)entityName withRootPath:(NSString *)rootPath;

- (EKFieldMapping *)primaryKeyFieldMapping;

#pragma mark - unavalable methods

- (instancetype)initWithObjectClass:(Class)objectClass EKDesignatedInitializer(initWithEntityName:);
- (instancetype)initWithObjectClass:(Class)objectClass withRootPath:(NSString *)rootPath EKDesignatedInitializer(initWithEntityName:withRootPath:);

+ (instancetype)mappingForClass:(Class)objectClass withBlock:(void(^)(EKObjectMapping *mapping))mappingBlock EKDesignatedInitializer(mappingForEntityName:withBlock:);
+ (instancetype)mappingForClass:(Class)objectClass withRootPath:(NSString *)rootPath
                      withBlock:(void (^)(EKObjectMapping *mapping))mappingBlock EKDesignatedInitializer(mappingForEntityName:withRootPath:withBlock);
@end
