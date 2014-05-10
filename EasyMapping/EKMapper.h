//
//  EKMapper.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EKManagedObjectMapping.h"
#import "EKObjectMapping.h"

@interface EKMapper : NSObject

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                           withMapping:(EKObjectMapping *)mapping;

+ (id)            fillObject:(id)object
  fromExternalRepresentation:(NSDictionary *)externalRepresentation
                 withMapping:(EKObjectMapping *)mapping;

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKObjectMapping *)mapping;

@end
