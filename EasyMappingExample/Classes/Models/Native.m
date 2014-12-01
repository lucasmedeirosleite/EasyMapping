//
//  Native.m
//  EasyMappingExample
//
//  Created by Philip Vasilchenko on 15.07.13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "Native.h"

@implementation Native

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:[Native class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[
                                      @"charProperty", @"unsignedCharProperty", @"shortProperty", @"unsignedShortProperty", @"intProperty", @"unsignedIntProperty",
                                      @"integerProperty", @"unsignedIntegerProperty", @"longProperty", @"unsignedLongProperty", @"longLongProperty",
                                      @"unsignedLongLongProperty", @"floatProperty", @"cgFloatProperty", @"doubleProperty", @"boolProperty", @"smallBoolProperty"
                                      ]];
    }];
}

@end
