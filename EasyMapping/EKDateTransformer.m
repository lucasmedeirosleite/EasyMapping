//
//  EKDateTransformer.m
//  EasyMappingExample
//
//  Created by Ilya Puchka on 25.01.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import "EKDateTransformer.h"

NSString * const EKRFC_3339DatetimeFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
NSString * const EKRFC_822DatetimeFormat = @"EEE, dd MMM yyyy HH:mm:ss z";

@interface EKDateTransformer()

@property (nonatomic, strong) void(^setupBlock)(EKDateTransformer *me);

@end

@implementation EKDateTransformer

@synthesize dateFormatter = _dateFormatter;

- (instancetype)initWithDateFormatter:(NSDateFormatter *)dateFormatter
{
    self = [super init];
    if (self) {
        _dateFormatter = dateFormatter;
    }
    return self;
}

+ (EKDateTransformer *)defaultDateTransformer
{
    static EKDateTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDateFormatter *dateFormatter;
        dateFormatter = [[NSDateFormatter alloc] init];
        transformer = [[self alloc] initWithDateFormatter:dateFormatter];
        [transformer resetToDefaults];
    });
    return transformer;
}

+ (void(^)(EKDateTransformer *))defaultSetupBlock {
    return ^ void(EKDateTransformer *me) {
        me.dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        me.dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        me.dateFormatter.dateFormat = EKRFC_3339DatetimeFormat;
    };
}

- (void)setupWithBlock:(void (^)(EKDateTransformer *))setupBlock
{
    self.setupBlock = setupBlock;
}

- (void)resetToDefaults
{
    [EKDateTransformer defaultSetupBlock](self);
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

+ (Class)transformedValueClass
{
    return [NSDate class];
}

- (void)setup
{
    if (self.setupBlock) {
        self.setupBlock(self);
        self.setupBlock = nil;
    }
}

- (id)transformedValue:(id)value
{
    [self setup];
    return [self.dateFormatter dateFromString:value];
}

- (id)reverseTransformedValue:(id)value
{
    [self setup];
    return [self.dateFormatter stringFromDate:value];
}

@end
