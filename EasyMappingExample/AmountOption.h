//
// Created by Roman Petryshen on 08/05/15.
// Copyright (c) 2015 EasyKit. All rights reserved.
//

#import "Option.h"

@interface AmountOption : Option
@property(nonatomic, strong) NSNumber *min;
@property(nonatomic, strong) NSNumber *max;
@property(nonatomic, strong) NSNumber *value;
@end