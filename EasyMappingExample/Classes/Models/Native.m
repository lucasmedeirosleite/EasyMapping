//
//  Native.m
//  EasyMappingExample
//
//  Created by Philip Vasilchenko on 15.07.13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "Native.h"

@implementation Native

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
