//
//  Plane.m
//  EasyMappingExample
//
//  Created by Dany L'Hebreux on 2013-10-03.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "Plane.h"
#import "Person.h"

@implementation Plane

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:[Plane class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapKeyPath:@"flight_number" toProperty:@"flightNumber"];
        [mapping hasMany:[Person class] forKeyPath:@"persons"];
    }];
}

@end
