//
//  EKTransformer.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EKTransformer.h"

NSString * const EKRailsDefaultDatetimeFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
NSString * const EKBrazilianDefaultDateFormat = @"dd/MM/yyyy";

@implementation EKTransformer

+ (NSDate *)transformString:(NSString *)stringToBeTransformed withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    format.dateFormat = dateFormat;
    return [format dateFromString:stringToBeTransformed];
}

@end
