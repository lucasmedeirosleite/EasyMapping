//
//  EKDateTransformer.h
//  EasyMappingExample
//
//  Created by Ilya Puchka on 25.01.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const EKRFC_3339DatetimeFormat; //yyyy-MM-dd'T'HH:mm:ss'Z'
extern NSString * const EKRFC_822DatetimeFormat; //EEE, dd MMM yyyy HH:mm:ss z
/**
 Class used to transform NSString to NSDate and back.
 
 Default date formatter setup:
 
    Locale: en_US_POSIX
    Timezone: GMT
    Date format: RFC 3339
 
 @warning NSDateFormatter (and so EKDateTransformer) is thread safe only on iOS 7 and later and on OS X 10.9 and later. (https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSDateFormatter_Class/index.html#//apple_ref/occ/cl/NSDateFormatter)
 
 */
@interface EKDateTransformer : NSValueTransformer

//Creates new transformer with specified date formatter.
- (instancetype)initWithDateFormatter:(NSDateFormatter *)dateFormatter;

//Returns singletone instance of EKDateTransformer with default date formatter setup. If you change it's date formatter, changes will take place everywhere where this instance is used.
+ (instancetype)defaultDateTransformer;

//Stores (and retains) setup block for this instance. It will be called later in -transformedValue and -reverseTransformedValue:.
- (void)setupWithBlock:(void(^)(EKDateTransformer *me))setupBlock;

//Resets transformer's date formatter to defaults: en_US_POSIX locale, GMT timezone, RFC 3339 date format.
- (void)resetToDefaults;

@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;

@end
