//
//  EKManagedObjectMapping.h
//  EasyMappingExample
//
//  Created by Alejandro Isaza on 2013-03-13.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

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
