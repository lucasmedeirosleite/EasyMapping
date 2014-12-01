//
//  Finger.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros Leite on 12/7/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "Finger.h"

@implementation Finger

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:[Finger class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"name"]];
    }];
}

@end
