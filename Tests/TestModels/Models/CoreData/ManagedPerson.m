//
//  Person.m
//  EasyMappingCoreDataExample
//
//  Created by Alejandro Isaza on 2013-03-14.
//
//

#import "ManagedPerson.h"
#import "Car.h"


@implementation ManagedPerson

@dynamic personID;
@dynamic name;
@dynamic email;
@dynamic car;
@dynamic phones;
@dynamic gender;
@dynamic relative;
@dynamic children;

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
