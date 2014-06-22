//
//  EKCoreDataModel.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKCoreDataModel.h"
#import "EKManagedObjectMapper.h"
#import "EKManagedObjectMapping.h"
#import "EKSerializer.h"

@implementation EKCoreDataModel

+(instancetype)objectWithProperties:(NSDictionary *)properties inContext:(NSManagedObjectContext *)context
{
    return [EKManagedObjectMapper objectFromExternalRepresentation:properties
                                                       withMapping:[self objectMapping]
                                            inManagedObjectContext:context];
}

- (NSDictionary *)serializedObject
{
    return [EKSerializer serializeObject:self
                             withMapping:[self.class objectMapping]];
}

+(EKManagedObjectMapping *)objectMapping
{
    return [[EKManagedObjectMapping alloc] initWithEntityName:NSStringFromClass(self)];
}

@end
