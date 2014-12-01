//
//  Three.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "Three.h"
#import "One.h"
#import "Two.h"

@implementation Three

@dynamic one;
@dynamic twos;

+(EKManagedObjectMapping *)objectMapping
{
    EKManagedObjectMapping * mapping = [super objectMapping];
    
    [mapping hasOne:[One class] forKeyPath:@"one"];
    [mapping hasMany:[Two class] forKeyPath:@"twos"];
    
    return mapping;
}

@end
