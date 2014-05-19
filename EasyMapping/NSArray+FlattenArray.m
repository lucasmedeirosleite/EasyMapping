//
//  NSArray+FlattenArray.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 11.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "NSArray+FlattenArray.h"

@implementation NSArray (FlattenArray)

-(NSArray*)ek_flattenedArray {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    for (id thing in self) {
        if ([thing isKindOfClass:[NSArray class]]) {
            [result addObjectsFromArray:[(NSArray*)thing ek_flattenedArray]];
        } else {
            [result addObject:thing];
        }
    }
    return [NSArray arrayWithArray:result];
}

@end
