//
//  EKObjectMapping+Utils.h
//  EasyMappingExample
//
//  Created by Ilya Puchka on 25.01.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import "EKObjectMapping.h"

typedef NS_ENUM(NSUInteger, EKTimestampUnit) {
    EKTimestampUnitSeconds,
    EKTimestampUnitMilliseconds
};

@interface EKObjectMapping (Utils)

#pragma mark - NSNumber
- (void)ek_mapIntegerAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property;
- (void)ek_mapIntAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property;
- (void)ek_mapFloatAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property;
- (void)ek_mapDoubleAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property;
- (void)ek_mapBoolAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property;

#pragma mark - NSString

- (void)ek_mapLocalizedStringAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property;

- (void)ek_mapLocalizedStringAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property comment:(NSString *)comment;

- (void)ek_mapLocalizedStringAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property comment:(NSString *)comment table:(NSString *)table;

- (void)ek_mapLocalizedStringAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property comment:(NSString *)comment table:(NSString *)table value:(NSString *)value;

- (void)ek_mapLocalizedStringAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property comment:(NSString *)comment table:(NSString *)table value:(NSString *)value bundle:(NSBundle *)bundle;


#pragma mark - NSURL
- (void)ek_mapURLatKeyPath:(NSString *)keyPath toProperty:(NSString *)property;

#pragma mark - NSDate
- (void)ek_mapTimestampAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property withUnit:(EKTimestampUnit)unit;

#pragma mark - CLLocation

//For mapping locations if form of dictionary: {"lng": 12.345, "lat": 12.345}
- (void)ek_mapCoordinatesAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property withLatitudeKey:(NSString *)latitudeKey longitudeKey:(NSString *)longitudeKey;

//For mapping locations if form of array: [12.345, 12.345]
- (void)ek_mapArrayCoordinatesAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property;

//For mapping locations if form of string: "12.345,12.345"
- (void)ek_mapStringCoordinatesAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property;

#pragma mark - UIColor

//default prefix is '#'
- (void)ek_mapHexColorAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property;

- (void)ek_mapHexColorAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property withPrefix:(NSString *)prefix;

@end
