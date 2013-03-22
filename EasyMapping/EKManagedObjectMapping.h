//
//  EKManagedObjectMapping.h
//  EasyMappingExample
//
//  Created by Alejandro Isaza on 2013-03-13.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKMappingBlocks.h"
#import "EKObjectMapping.h"

@interface EKManagedObjectMapping : EKObjectMapping

@property (nonatomic, assign, readonly) NSString* entityName;

+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                       withBlock:(void(^)(EKManagedObjectMapping *mapping))mappingBlock;
+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                    withRootPath:(NSString *)rootPath
                                       withBlock:(void (^)(EKManagedObjectMapping *mapping))mappingBlock;

- (id)initWithEntityName:(NSString *)entityName;
- (id)initWithEntityName:(NSString *)entityName withRootPath:(NSString *)rootPath;

@end
