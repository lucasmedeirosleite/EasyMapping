//
//  EKSerializer.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKObjectMapping.h"
#import "EKSerializer.h"

@interface EKSerializer : NSObject

+ (NSMutableDictionary *)serializeObject:(id)object withMapping:(EKObjectMapping *)mapping;
+ (NSMutableDictionary *)serializeUsingEntityMappingCoreDataForObject:(id)object withObjectMapping:(EKObjectMapping *)objectMapping;
+ (NSArray *)serializeCollection:(NSArray *)collection withMapping:(EKObjectMapping *)mapping;

@end
