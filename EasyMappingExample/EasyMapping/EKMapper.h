//
//  EKMapper.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKObjectMapping.h"

@interface EKMapper : NSObject

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKObjectMapping *)mapping;
+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation withMapping:(EKObjectMapping *)mapping;

@end
