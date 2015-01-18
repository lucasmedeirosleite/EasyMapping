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

#import "EKTransformer.h"

NSString * const EKRailsDefaultDatetimeFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
NSString * const EKBrazilianDefaultDateFormat = @"dd/MM/yyyy";

NSString * const kDateFormatterKey = @"SCDateFormatter";

@implementation EKTransformer

#pragma mark - Date/String

+ (NSDate *)transformString:(NSString *)stringToBeTransformed withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *format = [self dateFormatter];
    format.dateFormat = dateFormat;
    return [format dateFromString:stringToBeTransformed];
}

+ (NSString *)transformDate:(NSDate *)dateToBeTransformed withDateFormat:(NSString *)dateFormat {
    NSDateFormatter *format = [self dateFormatter];
    format.dateFormat = dateFormat;
    return [format stringFromDate:dateToBeTransformed];
}

+ (NSDateFormatter *)dateFormatter
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:kDateFormatterKey];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [dictionary setObject:dateFormatter forKey:kDateFormatterKey];
    }
    return dateFormatter;
}

#pragma mark - Date/NSTimeInterval

+ (NSDate *)transformValue:(id)value withTimestampFormat:(EKTimestampFormat)timestampFormat
{
    NSTimeInterval doubleValue = [value doubleValue];
    if (timestampFormat == EKTimestampFormatMilliseconds) {
        doubleValue /= 1000.0;
    }
    return [NSDate dateWithTimeIntervalSince1970:doubleValue];
}

+ (NSNumber *)transformDate:(NSDate *)dateToBeTransformted withTimestampFormat:(EKTimestampFormat)timestampFormat
{
    NSTimeInterval timeInterval = [dateToBeTransformted timeIntervalSince1970];
    if (timestampFormat == EKTimestampFormatMilliseconds) {
        timeInterval *= 1000.0;
    }
    return @(timeInterval);
}

@end
