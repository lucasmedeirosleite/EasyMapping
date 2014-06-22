//
//  Alien.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros Leite on 12/7/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "Alien.h"
#import "Finger.h"

@implementation Alien

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:[Alien class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"name"]];
        [mapping hasMany:[Finger class] forKeyPath:@"fingers"];
    }];
}

@end
