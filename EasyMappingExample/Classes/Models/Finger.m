//
//  Finger.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros Leite on 12/7/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "Finger.h"

@implementation Finger

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
