//
//  MappingProvider.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "ManagedMappingProvider.h"
#import "ManagedCar.h"
#import "ManagedPhone.h"
#import "ManagedPerson.h"

@implementation ManagedMappingProvider

+(NSDateFormatter *)iso8601DateFormatter {
    NSDateFormatter * formatter = [NSDateFormatter new];
    formatter.dateFormat = EKISO_8601DateTimeFormat;
    return formatter;
}

+ (EKObjectMapping *)carMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedCar.class]];
    [mapping mapPropertiesFromDictionary:@{ @"id": @"carID" }];
    [mapping mapPropertiesFromArray:@[@"model", @"year"]];
    mapping.contextProvider.primaryKey = @"carID";
    return mapping;
}

+ (EKObjectMapping *)carWithRootKeyMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedCar.class] rootPath:@"data.car"];
    [mapping mapPropertiesFromDictionary:@{ @"id": @"carID" }];
    [mapping mapPropertiesFromArray:@[@"model", @"year"]];
    mapping.contextProvider.primaryKey = @"carID";
    return mapping;
}

+ (EKObjectMapping *)carNonNestedMapping {
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedCar.class]];
    [mapping mapPropertiesFromDictionary:@{
                                           @"carId": @"carID",
                                           @"carModel":@"model",
                                           @"carYear":@"year"
                                           }];
    mapping.contextProvider.primaryKey = @"carID";
    return mapping;
}

+ (EKObjectMapping *)carNestedAttributesMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedCar.class]];
    [mapping mapPropertiesFromDictionary:@{ @"id": @"carID" }];
    [mapping mapPropertiesFromArray:@[@"model"]];
    [mapping mapPropertiesFromDictionary:@{
                                           @"information.year" : @"year"
                                           }];
    return mapping;
}

+ (EKObjectMapping *)carWithDateMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedCar.class]];
    [mapping mapPropertiesFromDictionary:@{ @"id": @"carID" }];
    [mapping mapPropertiesFromArray:@[@"model", @"year"]];
    [mapping mapKeyPath:@"created_at" toProperty:@"createdAt" withDateFormatter:[self iso8601DateFormatter]];
    mapping.contextProvider.primaryKey = @"carID";
    return mapping;
}

+ (EKObjectMapping *)phoneMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedPhone.class]];
    [mapping mapPropertiesFromDictionary:@{ @"id": @"phoneID" }];
    [mapping mapPropertiesFromArray:@[@"number"]];
    [mapping mapPropertiesFromDictionary:@{
                                           @"ddi" : @"ddi",
                                           @"ddd" : @"ddd"
                                           }];
    mapping.contextProvider.primaryKey = @"phoneID";
    return mapping;
}

+(EKObjectMapping *)personNonNestedMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedPerson.class]];
    [mapping mapPropertiesFromArray:@[@"name", @"email", @"gender"]];
    
    [mapping hasOne:[ManagedCar class] forDictionaryFromKeyPaths:@[@"carId",@"carModel",@"carYear"]
        forProperty:@"car" withObjectMapping:[self carNonNestedMapping]];
    mapping.contextProvider.primaryKey = @"personID";
    return mapping;
}

+ (EKObjectMapping *)personMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedPerson.class]];
    [mapping mapPropertiesFromDictionary:@{ @"id": @"personID" }];
    [mapping mapPropertiesFromArray:@[@"name", @"email", @"gender"]];
    [mapping hasOne:ManagedCar.class forKeyPath:@"car"];
    [mapping hasOne:ManagedPerson.class forKeyPath:@"relative"];
    [mapping hasMany:ManagedPerson.class forKeyPath:@"children"];
    [mapping hasMany:ManagedPhone.class forKeyPath:@"phones"];
    mapping.contextProvider.primaryKey = @"personID";
    return mapping;
}

+(EKObjectMapping *)personWithReverseBlocksMapping
{
    EKObjectMapping * personMapping = [self personWithCarMapping];
    [personMapping mapKeyPath:@"gender" toProperty:@"gender"
               withValueBlock:^id(EKMappingContext * context) {
                   if ([context.value isEqualToString:@"male"])
                   {
                       return @"husband";
                   }
                   else if ([context.value isEqualToString:@"female"])
                   {
                       return @"wife";
                   }
                   return nil;
               } reverseBlock:^id(EKMappingContext * context) {
                   if ([context.value isEqualToString:@"husband"])
                   {
                       return @"male";
                   }
                   else if ([context.value isEqualToString:@"wife"])
                   {
                       return @"female";
                   }
                   return nil;
               }];
    
    return personMapping;
}

+ (EKObjectMapping *)personWithCarMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedPerson.class]];
    [mapping mapPropertiesFromDictionary:@{ @"id": @"personID" }];
    [mapping mapPropertiesFromArray:@[@"name", @"email"]];
    [mapping hasOne:[ManagedCar class] forKeyPath:@"car"];
    mapping.contextProvider.primaryKey = @"personID";
    return mapping;
}

+ (EKObjectMapping *)personWithPhonesMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedPerson.class]];
    [mapping mapPropertiesFromDictionary:@{ @"id": @"personID" }];
    [mapping mapPropertiesFromArray:@[@"name", @"email"]];
    [mapping hasMany:[ManagedPhone class] forKeyPath:@"phones"];
    mapping.contextProvider.primaryKey = @"personID";
    return mapping;
}

+ (EKObjectMapping *)personWithOnlyValueBlockMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedPerson.class]];
    [mapping mapPropertiesFromDictionary:@{ @"id": @"personID" }];
    [mapping mapPropertiesFromArray:@[@"name", @"email", @"gender"]];
    mapping.contextProvider.primaryKey = @"personID";
    return mapping;
}

+(EKObjectMapping *)complexPlaneMapping
{
    EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithContextProvider:[[EKManagedMappingContextProvider alloc] initWithObjectClass:ManagedPerson.class]];
    [mapping hasOne:[ManagedPerson class] forKeyPath:@"captain"];
    [mapping hasMany:[ManagedPerson class] forKeyPath:@"persons"];
    return mapping;
}

@end
