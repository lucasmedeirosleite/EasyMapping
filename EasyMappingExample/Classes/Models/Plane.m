//
//  Plane.m
//  EasyMappingExample
//
//  Created by Dany L'Hebreux on 2013-10-03.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "Plane.h"

@implementation Plane

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
