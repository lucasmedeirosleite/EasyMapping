//
//  EKManagedObjectModel.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKManagedObjectModel.h"
#import "EKManagedObjectMapper.h"
#import "EKManagedObjectMapping.h"
#import "EKSerializer.h"

@implementation EKManagedObjectModel

#pragma mark - constructors

+(instancetype)objectWithProperties:(NSDictionary *)properties inContext:(NSManagedObjectContext *)context
{
    return [EKManagedObjectMapper objectFromExternalRepresentation:properties
                                                       withMapping:[self objectMapping]
                                            inManagedObjectContext:context];
}

#pragma mark - serialization

- (NSDictionary *)serializedObjectInContext:(NSManagedObjectContext *)context
{
    return [EKSerializer serializeObject:self
                             withMapping:[self.class objectMapping]
                             fromContext:context];
}

#pragma mark - EKManagedMappingProtocol

+(EKManagedObjectMapping *)objectMapping
{
    return [[EKManagedObjectMapping alloc] initWithEntityName:NSStringFromClass(self)];
}

@end
