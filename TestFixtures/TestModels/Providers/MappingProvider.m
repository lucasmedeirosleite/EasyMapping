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
#import "Finger.h"
#import "Native.h"
#import "Cat.h"
#import "CommentObject.h"
#import "Dog.h"
#import "Wolf.h"

@implementation MappingProvider

+(NSDateFormatter *)iso8601DateFormatter {
    NSDateFormatter * formatter = [NSDateFormatter new];
    formatter.dateFormat = EKISO_8601DateTimeFormat;
    return formatter;
}

+ (EKObjectMapping *)carMapping
{
    return [EKObjectMapping mappingForClass:[Car class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapKeyPath:@"id" toProperty:@"carId"];
        [mapping mapPropertiesFromArray:@[@"model", @"year"]];
    }];
}

+ (EKObjectMapping *)carWithRootKeyMapping
{
    return [EKObjectMapping mappingForClass:[Car class] withRootPath:@"data.car" withBlock:^(EKObjectMapping *mapping) {
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
        [mapping mapKeyPath:@"created_at" toProperty:@"createdAt" withDateFormatter:[self iso8601DateFormatter]];
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
        [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(EKMappingContext * context) {
            return genders[context.value];
        } reverseBlock:^id(EKMappingContext * context) {
            return [genders allKeysForObject:context.value].lastObject;
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
        [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(EKMappingContext * context) {
            return genders[context.value];
        } reverseBlock:^id(EKMappingContext * context) {
           return [genders allKeysForObject:context.value].lastObject;
        }];
        [mapping hasOne:[Car class] forKeyPath:@"car"];
        [mapping hasMany:[Phone class] forKeyPath:@"phones"];
        [mapping mapKeyPath:@"socialURL" toProperty:@"socialURL"
             withValueBlock:[EKMappingBlocks urlMappingBlock]
               reverseBlock:[EKMappingBlocks urlReverseMappingBlock]];
    }];
}

+(EKObjectMapping *)personMappingThatAssertsOnNilInValueBlock
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(EKMappingContext * context) {
            if (context.value == nil) { [[[NSException alloc] initWithName:@"Received nil value" reason:@"In value block when ignore missing fields is turned on" userInfo:nil] raise]; }
            return genders[context.value];
        } reverseBlock:^id(EKMappingContext * context) {
            return [genders allKeysForObject:context.value].lastObject;
        }];
        [mapping hasOne:[Car class] forKeyPath:@"car"];
        [mapping hasMany:[Phone class] forKeyPath:@"phones"];
        [mapping mapKeyPath:@"socialURL" toProperty:@"socialURL"
             withValueBlock:[EKMappingBlocks urlMappingBlock]
               reverseBlock:[EKMappingBlocks urlReverseMappingBlock]];
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
        [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(EKMappingContext * context) {
            return genders[context.value];
        } reverseBlock:^id(EKMappingContext * context) {
            return [[genders allKeysForObject:context.value] lastObject];
        }];
    }];
}

+ (EKObjectMapping *)personWithRelativeMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(EKMappingContext * context) {
            return genders[context.value];
        } reverseBlock:^id(EKMappingContext * context) {
            return [[genders allKeysForObject:context.value] lastObject];
        }];
        [mapping hasOne:[Person class] forKeyPath:@"relative"];
        [mapping hasMany:[Person class] forKeyPath:@"children"];
    }];
}

+ (EKObjectMapping *)addressMapping
{
    return [EKObjectMapping mappingForClass:[Address class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"street"]];
        [mapping mapKeyPath:@"location" toProperty:@"location" withValueBlock:^(EKMappingContext * context) {
            CLLocationDegrees latitudeValue = [[context.value objectAtIndex:0] doubleValue];
            CLLocationDegrees longitudeValue = [[context.value objectAtIndex:1] doubleValue];
            return [[CLLocation alloc] initWithLatitude:latitudeValue longitude:longitudeValue];
        } reverseBlock:^(EKMappingContext * context) {
            return @[ @([context.value coordinate].latitude), @([context.value coordinate].longitude) ];
        }];
    }];
}

+ (EKObjectMapping *)nativeMappingWithNullPropertie
{
    return [EKObjectMapping mappingForClass:[Cat class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[ @"age" ]];
    }];
}

+(EKObjectMapping *)personWithPetsMapping
{
    EKObjectMapping * mapping = [self personMapping];
    EKRelationshipMapping * relationship = [mapping hasMany:Dog.class forKeyPath:@"animals" forProperty:@"pets"];
    relationship.mappingResolver = ^EKObjectMapping *(id representation){
        if ([representation[@"type"] isEqualToString:@"dog"]) {
            return [Dog objectMapping];
        } else {
            return [Wolf objectMapping];
        }
    };
    return mapping;
}

+(EKObjectMapping *)personMappingThatIgnoresSocialUrlDuringSerialization
{
    EKObjectMapping *mapping = [self personMapping];
    [mapping mapKeyPath:@"socialURL" toProperty:@"socialURL"
         withValueBlock:[EKMappingBlocks urlMappingBlock]
           reverseBlock:^id _Nullable(id  _Nullable value) { return nil; }];
    return mapping;
}

@end
