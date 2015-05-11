//
// Created by Roman Petryshen on 08/05/15.
// Copyright (c) 2015 EasyKit. All rights reserved.
//

#import "Option.h"
#import "BooleanOption.h"
#import "AmountOption.h"


@implementation Option

+ (EKObjectMapping *)objectMapping {
    return [EKObjectMapping mappingForClass:[Option class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"optionId", @"title"]];

        [mapping mapKeyPath:@"type" toProperty:@"type" withValueBlock:^id(NSString *key, NSString *value) {
            return @(getOptionTypeFromString(value));
        }];

        [mapping setClassMutationBlock:[self mutationBlock]];
    }];
}


+ (EKObjectMappingMutationBlock)mutationBlock {
    return ^(NSDictionary *dictionary) {
        OptionType type = getOptionTypeFromString(dictionary[@"type"]);

        Class finalClass = self;

        switch (type) {
            case OptionTypeNone:
                break;
            case OptionTypeBoolean:
                finalClass = BooleanOption.class;
                break;
            case OptionTypeAmount:
                finalClass = AmountOption.class;
                break;
        }

        return finalClass;
    };
}


@end