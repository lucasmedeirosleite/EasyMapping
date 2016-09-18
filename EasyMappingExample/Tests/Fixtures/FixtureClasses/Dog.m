//
//  Dog.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 18.09.16.
//  Copyright © 2016 EasyKit. All rights reserved.
//

#import "Dog.h"

@implementation Dog

@synthesize family;

+ (EKObjectMapping *)objectMapping {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping * _Nonnull mapping) {
        [mapping mapKeyPath:@"family" toProperty:@"family"];
    }];
}

@end
