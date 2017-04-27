//
//  Cat.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 18.09.16.
//  Copyright © 2016 EasyKit. All rights reserved.
//

#import "Wolf.h"

@implementation Wolf

@synthesize pack;

+ (EKObjectMapping *)objectMapping {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping * _Nonnull mapping) {
        [mapping mapKeyPath:@"pack" toProperty:@"pack"];
    }];
}

@end
