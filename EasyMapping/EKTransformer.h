//
//  EKTransformer.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKFieldMapping.h"

extern NSString * const EKBrazilianDefaultDateFormat;
extern NSString * const EKBrazilianDefaultDateFormat;

@interface EKTransformer : NSObject

+ (NSDate *)transformString:(NSString *)stringToBeTransformed withDateFormat:(NSString *)dateFormat;
+ (NSString *)transformDate:(NSDate *)dateToBeTransformed withDateFormat:(NSString *)dateFormat;

@end
