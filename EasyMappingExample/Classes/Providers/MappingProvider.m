//
//  MappingProvider.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "MappingProvider.h"
#import "Car.h"
#import "Phone.h"
#import "Person.h"
#import "Address.h"
#import "Native.h"
#import "Plane.h"
#import "Alien.h"
#import "UFO.h"
#import "ColoredUFO.h"
#import "Finger.h"
#import "NativeChild.h"
#import "Cat.h"
#import "CommentObject.h"

@implementation MappingProvider

+ (EKObjectMapping *)carMapping
{
    return [EKObjectMapping mappingForClass:[Car class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapKeyPath:@"id" toProperty:@"carId"];
        [mapping mapPropertiesFromArray:@[@"model", @"year"]];
    }];
}

+ (EKObjectMapping *)carWithRootKeyMapping
{
    return [EKObjectMapping mappingForClass:[Car class] withRootPath:@"car" withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{@"id":@"carId"}];
        [mapping mapPropertiesFromArray:@[@"model", @"year"]];
    }];
}

+ (EKObjectMapping *)carNestedAttributesMapping
{
    return [EKObjectMapping mappingForClass:[Car class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"model"]];
        [mapping mapPropertiesFromDictionary:@{
            @"information.year" : @"year"
        }];
    }];
}

+(EKObjectMapping *)carNonNestedMapping {
    return [EKObjectMapping mappingForClass:[Car class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"carId": @"carId",
                                               @"carModel":@"model",
                                               @"carYear":@"year"
                                               }];
    }];
}

+ (EKObjectMapping *)carWithDateMapping
{
    return [EKObjectMapping mappingForClass:[Car class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"model", @"year"]];
        [mapping mapKeyPath:@"created_at" toProperty:@"createdAt" withDateFormatter:[NSDateFormatter ek_formatterForCurrentThread]];
    }];
}

+ (EKObjectMapping *)phoneMapping
{
    return [EKObjectMapping mappingForClass:[Phone class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"number"]];
        [mapping mapPropertiesFromDictionary:@{
            @"ddi" : @"DDI",
            @"ddd" : @"DDD"
         }];
    }];
}

+(EKObjectMapping *)personNonNestedMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(NSString *key, id value) {
            return genders[value];
        } reverseBlock:^id(id value) {
            return [genders allKeysForObject:value].lastObject;
        }];
        
        [mapping hasOne:[Car class] forDictionaryFromKeyPaths:@[@"carId",@"carModel",@"carYear"]
            forProperty:@"car" withObjectMapping:[self carNonNestedMapping]];
  }];
}

+ (EKObjectMapping *)personMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(NSString *key, id value) {
            return genders[value];
        } reverseBlock:^id(id value) {
           return [genders allKeysForObject:value].lastObject;
        }];
        [mapping hasOne:[Car class] forKeyPath:@"car"];
        [mapping hasMany:[Phone class] forKeyPath:@"phones"];
    }];
}

+ (EKObjectMapping *)personWithCarMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        [mapping hasOne:[Car class] forKeyPath:@"car"];
    }];
}

+ (EKObjectMapping *)personWithPhonesMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        [mapping hasMany:[Phone class] forKeyPath:@"phones"];
    }];
}

+ (EKObjectMapping *)personWithOnlyValueBlockMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(NSString *key, id value) {
            return genders[value];
        } reverseBlock:^id(id value) {
            return [[genders allKeysForObject:value] lastObject];
        }];
    }];
}

+ (EKObjectMapping *)personWithRelativeMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(NSString *key, id value) {
            return genders[value];
        } reverseBlock:^id(id value) {
            return [[genders allKeysForObject:value] lastObject];
        }];
        [mapping hasOne:[Person class] forKeyPath:@"relative"];
        [mapping hasMany:[Person class] forKeyPath:@"children"];
    }];
}

+ (EKObjectMapping *)addressMapping
{
    return [EKObjectMapping mappingForClass:[Address class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"street"]];
        [mapping mapKeyPath:@"location" toProperty:@"location" withValueBlock:^(NSString *key, NSArray *locationArray) {
            CLLocationDegrees latitudeValue = [[locationArray objectAtIndex:0] doubleValue];
            CLLocationDegrees longitudeValue = [[locationArray objectAtIndex:1] doubleValue];
            return [[CLLocation alloc] initWithLatitude:latitudeValue longitude:longitudeValue];
        } reverseBlock:^(CLLocation *location) {
            return @[ @(location.coordinate.latitude), @(location.coordinate.longitude) ];
        }];
    }];
}

+ (EKObjectMapping *)nativeMappingWithNullPropertie
{
    return [EKObjectMapping mappingForClass:[Cat class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[ @"age" ]];
    }];
}

@end
