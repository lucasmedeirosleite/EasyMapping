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
        [mapping mapFieldsFromArray:@[@"model", @"year"]];
    }];
}

+ (EKObjectMapping *)carWithRootKeyMapping
{
    return [EKObjectMapping mappingForClass:[Car class] withRootPath:@"car" withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"model", @"year"]];
        [mapping mapFieldsFromDictionary:@{@"id":@"carId"}];
    }];
}

+ (EKObjectMapping *)carNestedAttributesMapping
{
    return [EKObjectMapping mappingForClass:[Car class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"model"]];
        [mapping mapFieldsFromDictionary:@{
            @"information.year" : @"year"
        }];
    }];
}

+ (EKObjectMapping *)carWithDateMapping
{
    return [EKObjectMapping mappingForClass:[Car class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"model", @"year"]];
        [mapping mapKey:@"created_at" toField:@"createdAt" withDateFormat:@"yyyy-MM-dd"];
    }];
}

+ (EKObjectMapping *)phoneMapping
{
    return [EKObjectMapping mappingForClass:[Phone class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"number"]];
        [mapping mapFieldsFromDictionary:@{
            @"ddi" : @"DDI",
            @"ddd" : @"DDD"
         }];
    }];
}

+ (EKObjectMapping *)personMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping mapKey:@"gender" toField:@"gender" withValueBlock:^(NSString *key, id value) {
            return genders[value];
        } withReverseBlock:^id(id value) {
           return [genders allKeysForObject:value].lastObject;
        }];
        [mapping hasOne:[Car class] forKeyPath:@"car"];
        [mapping hasMany:[Phone class] forKeyPath:@"phones"];
    }];
}

+ (EKObjectMapping *)personWithCarMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping hasOne:[Car class] forKeyPath:@"car"];
    }];
}

+ (EKObjectMapping *)personWithPhonesMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping hasMany:[Phone class] forKeyPath:@"phones"];
    }];
}

+ (EKObjectMapping *)personWithOnlyValueBlockMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping mapKey:@"gender" toField:@"gender" withValueBlock:^(NSString *key, id value) {
            return genders[value];
        } withReverseBlock:^id(id value) {
            return [[genders allKeysForObject:value] lastObject];
        }];
    }];
}

+ (EKObjectMapping *)personWithRelativeMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping mapKey:@"gender" toField:@"gender" withValueBlock:^(NSString *key, id value) {
            return genders[value];
        } withReverseBlock:^id(id value) {
            return [[genders allKeysForObject:value] lastObject];
        }];
        [mapping hasOne:[Person class] forKeyPath:@"relative"];
        [mapping hasMany:[Person class] forKeyPath:@"children"];
    }];
}

+ (EKObjectMapping *)addressMapping
{
    return [EKObjectMapping mappingForClass:[Address class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"street"]];
        [mapping mapKey:@"location" toField:@"location" withValueBlock:^(NSString *key, NSArray *locationArray) {
            CLLocationDegrees latitudeValue = [[locationArray objectAtIndex:0] doubleValue];
            CLLocationDegrees longitudeValue = [[locationArray objectAtIndex:1] doubleValue];
            return [[CLLocation alloc] initWithLatitude:latitudeValue longitude:longitudeValue];
        } withReverseBlock:^(CLLocation *location) {
            return @[ @(location.coordinate.latitude), @(location.coordinate.longitude) ];
        }];
    }];
}

+ (EKObjectMapping *)nativeMappingWithNullPropertie
{
    return [EKObjectMapping mappingForClass:[Cat class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[ @"age" ]];
    }];
}

@end
