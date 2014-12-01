//
//  UFO.m
//  EasyMappingExample
//
//  Created by Jack Shurpin on 4/1/14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "UFO.h"

@implementation UFO

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:[UFO class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"shape"]];
        [mapping hasOne:[Alien class] forKeyPath:@"captain"];
        [mapping hasMany:[Alien class] forKeyPath:@"crew"];
        
    }];
}

@end
