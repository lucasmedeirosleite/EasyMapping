//
//  NativeChild.m
//  EasyMappingExample
//
//  Created by Philip Vasilchenko on 09.12.13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "NativeChild.h"

@implementation NativeChild

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:[NativeChild class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"intProperty", @"boolProperty", @"childProperty"]];
    }];
}

@end
