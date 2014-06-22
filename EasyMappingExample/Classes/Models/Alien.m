//
//  Alien.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros Leite on 12/7/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "Alien.h"

@implementation Alien

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
