//
//  EasyMapping
//
//  Copyright (c) 2012-2014 Lucas Medeiros.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSArray+Flatten_Map.h"

@implementation NSArray (Flatten_Map)

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

- (NSArray *)ek_mappedArray:(id (^)(id))block
{
    NSMutableArray *array = [NSMutableArray new];
    for (id item in self) {
        [array addObject:block(item)?:[NSNull null]];
    }
    return [array copy];
}

@end
