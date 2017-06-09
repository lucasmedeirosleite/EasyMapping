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
