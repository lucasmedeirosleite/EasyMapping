//
//  Car.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "Car.h"

@implementation Car

static EKObjectMapping * mapping = nil;

+(void)registerMapping:(EKObjectMapping *)objectMapping
{
    mapping = objectMapping;
}

+(EKObjectMapping *)objectMapping
{
    return mapping;
}

- (BOOL)isEqual:(Car *)object
{
    if (object == self) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return (object.carId == self.carId &&
            ([object.model isEqual:self.model] || (object.model == nil && self.model == nil)) &&
            ([object.year isEqual:self.year] || (object.year == nil && self.year == nil)));
}

@end
