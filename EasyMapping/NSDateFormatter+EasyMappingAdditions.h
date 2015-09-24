//
//  NSDateFormatter+EasyMappingAdditions.h
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

#import <Foundation/Foundation.h>

static NSString * const EKRFC_3339DatetimeFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
static NSString * const EKRFC_822DatetimeFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
static NSString * const EKISO_8601DateTimeFormat = @"yyyy-MM-dd";

/**
 Category on NSDateFormatter, that allows getting NSDateFormatter for current thread.
 
 Note. On iOS 7 and higher and Mac OS X 10.7 and higher NSDateFormatter is thread-safe, so it's safe to use date formatter across multiple threads.
 */

@interface NSDateFormatter (EasyMappingAdditions)

/**
 NSDateFormatter instance for current NSThread. It is lazily constructed, default date format - ISO 8601.
 */
+ (NSDateFormatter *)ek_formatterForCurrentThread;

@end
