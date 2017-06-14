//
//  Plane.m
//  EasyMappingExample
//
//  Created by Dany L'Hebreux on 2013-10-03.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "Plane.h"
#import "Person.h"
#import <EasyMapping/EasyMapping.h>

@implementation Plane

+(EKObjectMapping *)objectMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKObjectContextProvider alloc] initWithObjectClass:Plane.class]];
    [mapping mapKeyPath:@"flight_number" toProperty:@"flightNumber"];
    [mapping hasMany:[Person class] forKeyPath:@"persons"];
    return mapping;
}

@end

@implementation Seaplane

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
