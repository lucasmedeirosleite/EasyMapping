//
//  NativeChild.m
//  EasyMappingExample
//
//  Created by Philip Vasilchenko on 09.12.13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "NativeChild.h"

@implementation NativeChild

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
