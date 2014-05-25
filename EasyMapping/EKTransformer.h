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

#import "EKFieldMapping.h"

extern NSString * const EKRailsDefaultDatetimeFormat;
extern NSString * const EKBrazilianDefaultDateFormat;

/**
 `EKTransformer` is used to efficiently convert `NSString` to `NSDate` and reverse. By default, it uses GMT+0 timezone.
 */

@interface EKTransformer : NSObject

/**
 Transform string into date.
 
 @param stringToBeTransformed String, containing valid date.
 
 @param dateFormat Date format to be read from the string.
 
 @result NSDate object.
 */
+ (NSDate *)transformString:(NSString *)stringToBeTransformed withDateFormat:(NSString *)dateFormat;

/**
 Transform date into string.
 
 @param dateToBeTransformed Date to transform.
 
 @param dateFormat Date format to be written to string.
 
 @result NSString object.
 */
+ (NSString *)transformDate:(NSDate *)dateToBeTransformed withDateFormat:(NSString *)dateFormat;

@end
