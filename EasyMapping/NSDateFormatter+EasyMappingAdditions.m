//
//  NSDateFormatter+EasyMappingAdditions.m
//  EasyMapping
//
//  Created by Denys Telezhkin on 01.02.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
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

#import "NSDateFormatter+EasyMappingAdditions.h"

NSString * const EKThreadDateFormatterKey = @"EKThreadDateFormatter";

@implementation NSDateFormatter (EasyMappingAdditions)

+(NSDateFormatter *)ek_formatterForCurrentThread
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:EKThreadDateFormatterKey];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.dateFormat = EKISO_8601DateTimeFormat;
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [dictionary setObject:dateFormatter forKey:EKThreadDateFormatterKey];
    }
    return dateFormatter;
}

@end
