//
//  One.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "One.h"

@implementation One

@dynamic two;

+(EKManagedObjectMapping *)objectMapping
{
    EKManagedObjectMapping * mapping = [super objectMapping];
    
    [mapping hasOne:[Two class] forKeyPath:@"two"];
    
    return mapping;
}

@end
