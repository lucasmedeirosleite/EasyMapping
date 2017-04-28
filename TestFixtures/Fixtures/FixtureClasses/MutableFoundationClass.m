//
//  MutableFoundationClass.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 06.06.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import "MutableFoundationClass.h"

@implementation MutableFoundationClass

+(EKObjectMapping *)objectMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:self];
    
    [mapping mapPropertiesFromArray:@[@"array",@"dictionary", @"set"]];
    [mapping mapKeyPath:@"ordered_set" toProperty:@"orderedSet"];
    [mapping mapKeyPath:@"mutable_set" toProperty:@"mutableSet"];
    [mapping mapKeyPath:@"mutable_ordered_set" toProperty:@"mutableOrderedSet"];
    mapping.respectPropertyFoundationTypes = YES;
    return mapping;
}

@end
