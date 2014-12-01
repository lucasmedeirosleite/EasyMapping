//
//  Two.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "Two.h"

@implementation Two

@dynamic three;

+(EKManagedObjectMapping *)objectMapping
{
    EKManagedObjectMapping * mapping = [super objectMapping];
    
    [mapping hasOne:[Three class] forKeyPath:@"three"];
    
    return mapping;
}

@end

