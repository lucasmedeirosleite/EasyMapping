//
//  Phone.m
//  EasyMappingCoreDataExample
//
//  Created by Alejandro Isaza on 2013-03-14.
//
//

#import "ManagedPhone.h"
#import "Person.h"


@implementation ManagedPhone

@dynamic phoneID;
@dynamic ddi;
@dynamic ddd;
@dynamic number;

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
