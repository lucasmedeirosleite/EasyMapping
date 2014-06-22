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

static EKManagedObjectMapping * mapping = nil;

+(void)registerMapping:(EKManagedObjectMapping *)objectMapping
{
    mapping = objectMapping;
}

+(EKManagedObjectMapping *)objectMapping
{
    return mapping;
}

@end
