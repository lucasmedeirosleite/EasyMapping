//
//  EKObjectMapping+Utils.m
//  EasyMappingExample
//
//  Created by Ilya Puchka on 25.01.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import "EKObjectMapping+Utils.h"
#import <CoreLocation/CoreLocation.h>

UIColor *UIColorWithHexValue(NSString *hexValue, NSString *prefix) {
    NSString *hexString;
    if ([hexValue isKindOfClass:[NSNumber class]]) {
        hexString = [(NSNumber *)hexValue stringValue];
    }
    else {
        hexString = [hexValue stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    }
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:0];
    if ([scanner scanHexInt:&rgbValue]) {
        UIColor *color = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
        return color;
    }
    else {
        return nil;
    }
}

NSString *NSStringFromUIColor(UIColor *color, NSString *prefix) {
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue: &b alpha: &a];
    return [NSString stringWithFormat:@"%@%02x%02x%02x%02x", prefix,
            (int)(r * 255.0f), (int)(g * 255.0f), (int)(b * 255.0f), (int)(a * 255.0f)];
}

CLLocationCoordinate2D CLLocationCoordinate2DMakeFromArray(NSArray *array) {
    CLLocationDegrees latitude = [[array objectAtIndex:0] doubleValue];
    CLLocationDegrees longitude = [[array objectAtIndex:1] doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}

CLLocationCoordinate2D CLLocationCoordinate2DMakeFromDictionary(NSDictionary *dict, NSString *latitudeKey, NSString *longitudeKey) {
    CLLocationDegrees latitude = [[dict objectForKey:latitudeKey] doubleValue];
    CLLocationDegrees longitude = [[dict objectForKey:longitudeKey] doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}

CLLocationCoordinate2D CLLocationCoordinate2DMakeFromString(NSString *string) {
    return CLLocationCoordinate2DMakeFromArray([string componentsSeparatedByString:@","]);
}


@implementation EKObjectMapping (Utils)

#pragma mark - NSNumber

- (void)ek_mapIntegerAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    [self mapKeyPath:keyPath toProperty:property withValueBlock:^id(NSString *key, id value) {
        return @([value integerValue]);
    } reverseBlock:^id(id value) {
        return @([value integerValue]);
    }];
}

- (void)ek_mapIntAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    [self mapKeyPath:keyPath toProperty:property withValueBlock:^id(NSString *key, id value) {
        return @([value intValue]);
    } reverseBlock:^id(id value) {
        return @([value intValue]);
    }];
}

- (void)ek_mapFloatAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    [self mapKeyPath:keyPath toProperty:property withValueBlock:^id(NSString *key, id value) {
        return @([value floatValue]);
    } reverseBlock:^id(id value) {
        return @([value floatValue]);
    }];
}

- (void)ek_mapDoubleAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    [self mapKeyPath:keyPath toProperty:property withValueBlock:^id(NSString *key, id value) {
        return @([value doubleValue]);
    } reverseBlock:^id(id value) {
        return @([value doubleValue]);
    }];
}

- (void)ek_mapBoolAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    [self mapKeyPath:keyPath toProperty:property withValueBlock:^id(NSString *key, id value) {
        return @([value boolValue]);
    } reverseBlock:^id(id value) {
        return @([value boolValue]);
    }];
}

#pragma mark - NSString

- (void)ek_mapLocalizedStringAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    [self ek_mapLocalizedStringAtKeyPath:keyPath toProperty:property comment:nil table:nil value:@"" bundle:[NSBundle mainBundle]];
}

- (void)ek_mapLocalizedStringAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property comment:(NSString *)comment
{
    [self ek_mapLocalizedStringAtKeyPath:keyPath toProperty:property comment:comment table:nil value:@"" bundle:[NSBundle mainBundle]];
}

- (void)ek_mapLocalizedStringAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property comment:(NSString *)comment table:(NSString *)table
{
    [self ek_mapLocalizedStringAtKeyPath:keyPath toProperty:property comment:comment table:table value:@"" bundle:[NSBundle mainBundle]];
}

- (void)ek_mapLocalizedStringAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property comment:(NSString *)comment table:(NSString *)table value:(NSString *)value
{
    [self ek_mapLocalizedStringAtKeyPath:keyPath toProperty:property comment:comment table:table value:value bundle:[NSBundle mainBundle]];
}

- (void)ek_mapLocalizedStringAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property comment:(NSString *)comment table:(NSString *)table value:(NSString *)value bundle:(NSBundle *)bundle
{
    [self mapKeyPath:keyPath toProperty:property withValueBlock:^id(NSString *key, id _value) {
        return NSLocalizedStringWithDefaultValue(_value, table, bundle, value, comment);
    }];
}


#pragma mark - NSURL

- (void)ek_mapURLatKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    [self mapKeyPath:keyPath toProperty:property withValueBlock:^id(NSString *key, id value) {
        return [NSURL URLWithString:value];
    } reverseBlock:^id(NSURL *value) {
        return value.absoluteString;
    }];
}

#pragma mark - NSDate

- (void)ek_mapTimestampAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property withUnit:(EKTimestampUnit)unit
{
    [self mapKeyPath:keyPath toProperty:property withValueBlock:^id(NSString *key, id value) {
        NSTimeInterval timeInterval = [value doubleValue];
        if (unit == EKTimestampUnitMilliseconds) {
            timeInterval /= 1000;
        }
        return [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    } reverseBlock:^id(id value) {
        if (unit == EKTimestampUnitMilliseconds) {
            
        }
        return @([value boolValue]);
    }];
}

#pragma mark - CLLocation

- (void)ek_mapStringCoordinatesAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    [self ek_mapCoordinatesAtKeyPath:keyPath toProperty:property withValueBlock:^CLLocationCoordinate2D(id value) {
        return CLLocationCoordinate2DMakeFromString(value);
    } reverseBlock:^id(CLLocationCoordinate2D coords) {
        return [NSString stringWithFormat:@"%@,%@", @(coords.latitude), @(coords.longitude)];
    }];
}

- (void)ek_mapArrayCoordinatesAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    [self ek_mapCoordinatesAtKeyPath:keyPath toProperty:property withValueBlock:^CLLocationCoordinate2D(id value) {
        return CLLocationCoordinate2DMakeFromArray(value);
    } reverseBlock:^id(CLLocationCoordinate2D coords) {
        return @[@(coords.latitude), @(coords.longitude)];
    }];
}

- (void)ek_mapCoordinatesAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property withLatitudeKey:(NSString *)latitudeKey longitudeKey:(NSString *)longitudeKey
{
    [self ek_mapCoordinatesAtKeyPath:keyPath toProperty:property withValueBlock:^CLLocationCoordinate2D(id value) {
        return CLLocationCoordinate2DMakeFromDictionary(value, latitudeKey, longitudeKey);
    } reverseBlock:^id(CLLocationCoordinate2D coords) {
        return @{latitudeKey: @(coords.latitude), longitudeKey: @(coords.longitude)};
    }];
}

- (void)ek_mapCoordinatesAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property withValueBlock:(CLLocationCoordinate2D (^)(id))valueBlock reverseBlock:(id(^)(CLLocationCoordinate2D))reverseBlock
{
    [self mapKeyPath:keyPath
          toProperty:property
      withValueBlock:^id(NSString *key, id value) {
          CLLocationCoordinate2D coords = valueBlock(value);
          return [NSValue valueWithBytes:&coords objCType:@encode(CLLocationCoordinate2D)];
      }
        reverseBlock:^id(id value) {
            CLLocationCoordinate2D coords;
            [value getValue:&coords];
            return reverseBlock(coords);
        }];
}

#pragma mark - UIColor

- (void)ek_mapHexColorAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property
{
    [self ek_mapHexColorAtKeyPath:keyPath toProperty:property withPrefix:@"#"];
}

- (void)ek_mapHexColorAtKeyPath:(NSString *)keyPath toProperty:(NSString *)property withPrefix:(NSString *)prefix
{
    [self mapKeyPath:keyPath toProperty:property withValueBlock:^id(NSString *key, id value) {
        return UIColorWithHexValue(value, prefix);
    } reverseBlock:^id(UIColor *value) {
        return NSStringFromUIColor(value, prefix);
    }];
}

@end
