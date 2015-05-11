//
// Created by Roman Petryshen on 08/05/15.
// Copyright (c) 2015 EasyKit. All rights reserved.
//

#import "AmountOption.h"
#import "EKMapper.h"


@implementation AmountOption

+ (EKObjectMapping *)objectMapping {
    EKObjectMapping *mapping = [super objectMapping];
    [mapping mapPropertiesFromArray:@[@"min", @"max", @"value"]];
    return mapping;
}

@end