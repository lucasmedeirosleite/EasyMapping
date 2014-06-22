//
//  ColoredUFO.m
//  EasyMappingExample
//
//  Created by Jack Shurpin on 4/1/14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "ColoredUFO.h"

@implementation ColoredUFO

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:[ColoredUFO class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"color"]];
        [mapping mapPropertiesFromMappingObject:[super objectMapping]];
    }];
}

@end
