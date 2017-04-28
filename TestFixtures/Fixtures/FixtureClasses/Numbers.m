//
//  One.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "Numbers.h"

@implementation One

@dynamic two;

+(EKManagedObjectMapping *)objectMapping
{
    EKManagedObjectMapping * mapping = [super objectMapping];
    
    [mapping hasOne:[Two class] forKeyPath:@"two"];
    
    return mapping;
}

@end

@implementation Two

@dynamic three;

+(EKManagedObjectMapping *)objectMapping
{
    EKManagedObjectMapping * mapping = [super objectMapping];
    
    [mapping hasOne:[Three class] forKeyPath:@"three"];
    
    return mapping;
}

@end

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
