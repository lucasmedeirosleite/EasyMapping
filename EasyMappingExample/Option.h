//
// Created by Roman Petryshen on 08/05/15.
// Copyright (c) 2015 EasyKit. All rights reserved.
//

#import "BaseTestModel.h"

typedef NS_ENUM(NSUInteger, OptionType) {
    OptionTypeNone = 0,
    OptionTypeBoolean,
    OptionTypeAmount,
};

static OptionType getOptionTypeFromString(NSString *string) {
    NSString *loweString = string.lowercaseString;
    NSString *typeString = [loweString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    OptionType type = OptionTypeNone;

    if ([typeString isEqualToString:@"boolean"]) {
        type = OptionTypeBoolean;
    }
    else if ([typeString isEqualToString:@"amount"]) {
        type = OptionTypeAmount;
    }

    return type;
}


@interface Option : NSObject <EKMappingProtocol>

@property(nonatomic, strong) NSNumber *optionId;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) OptionType type;

@end