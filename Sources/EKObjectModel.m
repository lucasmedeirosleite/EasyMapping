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

@implementation EKObjectModel

#pragma mark - constructors

+(instancetype)objectWithProperties:(NSDictionary *)properties
{
    return [EKMapper objectFromExternalRepresentation:properties
                                          withMapping:[self objectMapping]];
}

-(instancetype)initWithProperties:(NSDictionary *)properties
{
    if (self = [super init])
    {
        [EKMapper fillObject:self
  fromExternalRepresentation:properties
                 withMapping:[self.class objectMapping]];
    }
    return self;
}

#pragma mark - serialization

- (NSDictionary *)serializedObject
{
    return [EKSerializer serializeObject:self
                             withMapping:[self.class objectMapping]];
}

#pragma mark - EKMappingProtocol

+(EKObjectMapping *)objectMapping
{
    return [[EKObjectMapping alloc] initWithObjectClass:self];
}

@end
