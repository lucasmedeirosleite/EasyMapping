//
//  Car.m
//  EasyMappingCoreDataExample
//
//  Created by Alejandro Isaza on 2013-03-14.
//
//

#import "ManagedCar.h"


@implementation ManagedCar

@dynamic carID;
@dynamic model;
@dynamic year;
@dynamic createdAt;
@dynamic person;

static EKObjectMapping * mapping = nil;

+(void)registerMapping:(EKObjectMapping *)objectMapping
{
    mapping = objectMapping;
}

+(EKObjectMapping *)objectMapping
{
    return mapping;
}

@end
