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

#define EKDesignatedInitializer(__SEL__) __attribute__((unavailable("Invoke the designated initializer `" # __SEL__ "` instead.")))

NS_ASSUME_NONNULL_BEGIN

/**
 `EKManagedObjectMapping` is a subclass of `EKObjectMapping`, intended to be used with CoreData objects.
 */

@interface EKManagedObjectMapping : EKObjectMapping

/**
 Entity name of CoreData object.
 */
@property (nonatomic, strong, readonly) NSString* entityName;

/**
 Primary key of CoreData objects
 */
@property (nonatomic, strong, nullable) NSString *primaryKey;

-(void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property withValueBlock:(EKManagedMappingValueBlock)valueBlock;

-(void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property
   withValueBlock:(EKManagedMappingValueBlock)valueBlock
     reverseBlock:(EKManagedMappingReverseValueBlock)reverseBlock;

/**
 Convenience constructor for `EKManagedObjectMapping`.
 
 @param entityName Name of CoreData entity.
 
 @param mappingBlock Block, that contains managed object mapping.
 
 @result managed object mapping.
 */
+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                       withBlock:(void(^)(EKManagedObjectMapping *mapping))mappingBlock;

/**
 Convenience constructor for `EKManagedObjectMapping`.
 
 @param entityName Name of CoreData entity.
 
 @param rootPath rootPath for mapping.
 
 @param mappingBlock Block, that contains managed object mapping
 
 @result managed object mapping.
 */
+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                    withRootPath:(NSString *)rootPath
                                       withBlock:(void (^)(EKManagedObjectMapping *mapping))mappingBlock;

/**
 Designated initializer for `EKManagedObjectMapping`.
 
 @param entityName CoreData entity name.
 
 @result managed object mapping.
 */
- (instancetype)initWithEntityName:(NSString *)entityName;

/**
 Designated initializer for `EKManagedObjectMapping`.
 
 @param entityName CoreData entity name.
 
 @param rootPath rootPath for mapping.
 
 @result managed object mapping.
 */
- (instancetype)initWithEntityName:(NSString *)entityName withRootPath:(NSString *)rootPath;

/**
 Property mapping for primary key of managed object.
 
 @result property mapping
 */
- (nullable EKPropertyMapping *)primaryKeyPropertyMapping;

#pragma mark - unavalable methods

/**
 This method is unavailable for `EKManagedObjectMapping`. Use `initWithEntityName:` method instead.
 */
- (instancetype)initWithObjectClass:(Class)objectClass EKDesignatedInitializer(initWithEntityName:);

/**
 This method is unavailable for `EKManagedObjectMapping`. Use `initWithEntityName:rootPath:` method instead.
 */
- (instancetype)initWithObjectClass:(Class)objectClass withRootPath:(NSString *)rootPath EKDesignatedInitializer(initWithEntityName:withRootPath:);

/**
 This method is unavailable for `EKManagedObjectMapping`. Use `mappingForEntityName:withBlock:` method instead.
 */
+ (instancetype)mappingForClass:(Class)objectClass withBlock:(void(^)(EKObjectMapping *mapping))mappingBlock EKDesignatedInitializer(mappingForEntityName:withBlock:);

/**
 This method is unavailable for `EKManagedObjectMapping`. Use `mappingForEntityName:rootPath:withBlock:` method instead.
 */
+ (instancetype)mappingForClass:(Class)objectClass withRootPath:(NSString *)rootPath
                      withBlock:(void (^)(EKObjectMapping *mapping))mappingBlock EKDesignatedInitializer(mappingForEntityName:withRootPath:withBlock);
@end

NS_ASSUME_NONNULL_END
