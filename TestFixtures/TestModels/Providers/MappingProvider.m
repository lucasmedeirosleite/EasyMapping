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
#import <EasyMapping/EKObjectContextProvider.h>
@implementation MappingProvider

+(NSDateFormatter *)iso8601DateFormatter {
    NSDateFormatter * formatter = [NSDateFormatter new];
    formatter.dateFormat = EKISO_8601DateTimeFormat;
    return formatter;
}

+ (EKObjectMapping *)carMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Car.class]];
    [mapping mapKeyPath:@"id" toProperty:@"carId"];
    [mapping mapPropertiesFromArray:@[@"model", @"year"]];
    return mapping;
}

+ (EKObjectMapping *)carWithRootKeyMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Car.class]
                                                                        rootPath:@"data.car"];
    [mapping mapPropertiesFromDictionary:@{@"id":@"carId"}];
    [mapping mapPropertiesFromArray:@[@"model", @"year"]];
    return mapping;
}

+ (EKObjectMapping *)carNestedAttributesMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Car.class]];
    [mapping mapPropertiesFromArray:@[@"model"]];
        [mapping mapPropertiesFromDictionary:@{
            @"information.year" : @"year"
        }];
    return mapping;
}

+(EKObjectMapping *)carNonNestedMapping {
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Car.class]];
    [mapping mapPropertiesFromDictionary:@{
                                           @"carId": @"carId",
                                           @"carModel":@"model",
                                           @"carYear":@"year"
                                           }];
    return mapping;
}

+ (EKObjectMapping *)carWithDateMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Car.class]];
    [mapping mapPropertiesFromArray:@[@"model", @"year"]];
    [mapping mapKeyPath:@"created_at" toProperty:@"createdAt" withDateFormatter:[self iso8601DateFormatter]];
    return mapping;
}

+ (EKObjectMapping *)phoneMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Phone.class]];
    [mapping mapPropertiesFromArray:@[@"number"]];
    [mapping mapPropertiesFromDictionary:@{
                                           @"ddi" : @"DDI",
                                           @"ddd" : @"DDD"
                                           }];
    return mapping;
}

+(EKObjectMapping *)personNonNestedMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Person.class]];
    NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
    [mapping mapPropertiesFromArray:@[@"name", @"email"]];
    [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(EKMappingContext * context) {
        return genders[context.value];
    } reverseBlock:^id(EKMappingContext * context) {
        return [genders allKeysForObject:context.value].lastObject;
    }];
    
    [mapping hasOne:[Car class] forDictionaryFromKeyPaths:@[@"carId",@"carModel",@"carYear"]
        forProperty:@"car" withObjectMapping:[self carNonNestedMapping]];
    return mapping;
}

+ (EKObjectMapping *)personMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Person.class]];
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
    return mapping;
}

+(EKObjectMapping *)personMappingThatAssertsOnNilInValueBlock
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Person.class]];
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
    return mapping;
}

+ (EKObjectMapping *)personWithCarMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Person.class]];
    [mapping mapPropertiesFromArray:@[@"name", @"email"]];
    [mapping hasOne:[Car class] forKeyPath:@"car"];
    return mapping;
}

+ (EKObjectMapping *)personWithPhonesMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Person.class]];
    [mapping mapPropertiesFromArray:@[@"name", @"email"]];
    [mapping hasMany:[Phone class] forKeyPath:@"phones"];
    return mapping;
}

+ (EKObjectMapping *)personWithOnlyValueBlockMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Person.class]];
    NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
    [mapping mapPropertiesFromArray:@[@"name", @"email"]];
    [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(EKMappingContext * context) {
        return genders[context.value];
    } reverseBlock:^id(EKMappingContext * context) {
        return [[genders allKeysForObject:context.value] lastObject];
    }];
    return mapping;
}

+ (EKObjectMapping *)personWithRelativeMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Person.class]];
    NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
    [mapping mapPropertiesFromArray:@[@"name", @"email"]];
    [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(EKMappingContext * context) {
        return genders[context.value];
    } reverseBlock:^id(EKMappingContext * context) {
        return [[genders allKeysForObject:context.value] lastObject];
    }];
    [mapping hasOne:[Person class] forKeyPath:@"relative"];
    [mapping hasMany:[Person class] forKeyPath:@"children"];
    return mapping;
}

+ (EKObjectMapping *)addressMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Address.class]];
    [mapping mapPropertiesFromArray:@[@"street"]];
    [mapping mapKeyPath:@"location" toProperty:@"location" withValueBlock:^(EKMappingContext * context) {
        CLLocationDegrees latitudeValue = [[context.value objectAtIndex:0] doubleValue];
        CLLocationDegrees longitudeValue = [[context.value objectAtIndex:1] doubleValue];
        return [[CLLocation alloc] initWithLatitude:latitudeValue longitude:longitudeValue];
    } reverseBlock:^(EKMappingContext * context) {
        return @[ @([context.value coordinate].latitude), @([context.value coordinate].longitude) ];
    }];
    return mapping;
}

+ (EKObjectMapping *)nativeMappingWithNullPropertie
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[EKObjectContextProvider providerWithObjectClass:Cat.class]];
    [mapping mapPropertiesFromArray:@[ @"age" ]];
    return mapping;
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
