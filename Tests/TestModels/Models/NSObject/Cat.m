//
//  Cat.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros Leite on 1/28/14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "Cat.h"

@implementation Cat

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
