//
//  EKObjectModel.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKObjectModel.h"
#import "EKMapper.h"
#import "EKSerializer.h"
#import "EKObjectContextProvider.h"

@implementation EKObjectModel

#pragma mark - constructors

+(instancetype)objectWithProperties:(NSDictionary *)properties
{
    EKMapper * mapper = [[EKMapper alloc] initWithMappingStore:[[EKObjectStore alloc] init]];
    return [mapper objectFromExternalRepresentation:properties
                                        withMapping:[self objectMapping]];
}

-(instancetype)initWithProperties:(NSDictionary *)properties
{
    if (self = [super init])
    {
        EKMapper * mapper = [[EKMapper alloc] initWithMappingStore:[[EKObjectStore alloc] init]];
        [mapper fillObject:self
  fromExternalRepresentation:properties
                 withMapping:[self.class objectMapping]];
    }
    return self;
}

#pragma mark - serialization

- (NSDictionary *)serializedObject
{
    EKSerializer * serializer = [[EKSerializer alloc] initWithMappingStore:[[EKObjectStore alloc] init]];
    return [serializer serializeObject:self
                             withMapping:[self.class objectMapping]];
}

#pragma mark - EKMappingProtocol

+(EKObjectMapping *)objectMapping
{
    return [[EKObjectMapping alloc] initWithContextProvider:[[EKObjectContextProvider alloc] initWithObjectClass:self]];
}

@end
