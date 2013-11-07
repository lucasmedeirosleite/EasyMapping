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
#import "Response.h"
#import "Playlist.h"

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
        [mapping hasOneMapping:[self carMapping] forKey:@"car"];
        [mapping hasManyMapping:[self phoneMapping] forKey:@"phones"];
    }];
}

+ (EKObjectMapping *)personWithCarMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping hasOneMapping:[self carMapping] forKey:@"car"];
    }];
}

+ (EKObjectMapping *)personWithPhonesMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping hasManyMapping:[self phoneMapping] forKey:@"phones"];
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

+ (EKObjectMapping *)nativeMapping
{
    return [EKObjectMapping mappingForClass:[Native class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[
         @"charProperty", @"unsignedCharProperty", @"shortProperty", @"unsignedShortProperty", @"intProperty", @"unsignedIntProperty",
         @"integerProperty", @"unsignedIntegerProperty", @"longProperty", @"unsignedLongProperty", @"longLongProperty",
         @"unsignedLongLongProperty", @"floatProperty", @"cgFloatProperty", @"doubleProperty", @"boolProperty"
        ]];
    }];
}

+ (EKObjectMapping *)planeMapping
{
    return [EKObjectMapping mappingForClass:[Plane class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapKey:@"flight_number" toField:@"flightNumber"];
        [mapping hasManyMapping:[self personMapping] forKey:@"persons"];
    }];
}

+ (EKObjectMapping *)playlistMapping
{
    return [EKObjectMapping mappingForClass:[Playlist class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"kind", @"etag"]];
        [mapping mapFieldsFromDictionary:@{
            @"id" : @"itemId"
        }];
        
        [mapping mapSubKey:@"publishedAt" ofKey:@"snippet" toField:@"publishedAt" withDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        [mapping mapSubValuesOfKey:@"snippet" toFieldsFromArray:@[@"channelId", @"title", @"channelTitle"]];
        [mapping mapSubValuesOfKey:@"snippet" toFieldsFromDictionary:@{
            @"description" : @"itemDescription"
         }];
        
        [mapping mapKey:@"snippet" toField:@"defaultUrl" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value;
            NSDictionary *thumbnails = dictionary[@"thumbnails"];
            NSDictionary *defaultThumbnail = thumbnails[@"default"];
            return defaultThumbnail[@"url"];
        }];
        
        [mapping mapKey:@"snippet" toField:@"mediumUrl" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value;
            NSDictionary *thumbnails = dictionary[@"thumbnails"];
            NSDictionary *defaultThumbnail = thumbnails[@"medium"];
            return defaultThumbnail[@"url"];
        }];
        
        [mapping mapKey:@"snippet" toField:@"highUrl" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *dictionary = (NSDictionary *)value;
            NSDictionary *thumbnails = dictionary[@"thumbnails"];
            NSDictionary *defaultThumbnail = thumbnails[@"high"];
            return defaultThumbnail[@"url"];
        }];
    }];
}

+ (EKObjectMapping *)responseMapping
{
    return [EKObjectMapping mappingForClass:[Response class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"kind", @"etag"]];
        [mapping hasManyMapping:[self playlistMapping] forKey:@"items"];
        [mapping mapSubValuesOfKey:@"pageInfo" toFieldsFromArray:@[@"totalResults", @"resultsPerPage"]];
    }];
}

@end
