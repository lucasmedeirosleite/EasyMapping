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

+ (EKManagedObjectMapping *)carMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedCar class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromDictionary:@{ @"id": @"carID" }];
        [mapping mapFieldsFromArray:@[@"model", @"year"]];
        mapping.primaryKey = @"carID";
    }];
}

+ (EKManagedObjectMapping *)carWithRootKeyMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedCar class])
                                           withRootPath:@"car"
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromDictionary:@{ @"id": @"carID" }];
        [mapping mapFieldsFromArray:@[@"model", @"year"]];
        mapping.primaryKey = @"carID";
    }];
}

+ (EKManagedObjectMapping *)carNestedAttributesMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedCar class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromDictionary:@{ @"id": @"carID" }];
        [mapping mapFieldsFromArray:@[@"model"]];
        [mapping mapFieldsFromDictionary:@{
            @"information.year" : @"year"
         }];
        mapping.primaryKey = @"carID";
    }];
}

+ (EKManagedObjectMapping *)carWithDateMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedCar class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromDictionary:@{ @"id": @"carID" }];
        [mapping mapFieldsFromArray:@[@"model", @"year"]];
        [mapping mapKey:@"created_at" toField:@"createdAt" withDateFormat:@"yyyy-MM-dd"];
        mapping.primaryKey = @"carID";
    }];
}

+ (EKManagedObjectMapping *)phoneMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedPhone class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromDictionary:@{ @"id": @"phoneID" }];
        [mapping mapFieldsFromArray:@[@"number"]];
        [mapping mapFieldsFromDictionary:@{
            @"ddi" : @"ddi",
            @"ddd" : @"ddd"
         }];
        mapping.primaryKey = @"phoneID";
    }];
}

+ (EKManagedObjectMapping *)personMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedPerson class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromDictionary:@{ @"id": @"personID" }];
        [mapping mapFieldsFromArray:@[@"name", @"email", @"gender"]];
        [mapping hasOneMapping:[self carMapping] forKey:@"car"];
        [mapping hasManyMapping:[self phoneMapping] forKey:@"phones"];
        mapping.primaryKey = @"personID";
    }];
}

+ (EKManagedObjectMapping *)personWithCarMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedPerson class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromDictionary:@{ @"id": @"personID" }];
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping hasOneMapping:[self carMapping] forKey:@"car"];
        mapping.primaryKey = @"personID";
    }];
}

+ (EKManagedObjectMapping *)personWithPhonesMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedPerson class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromDictionary:@{ @"id": @"personID" }];
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping hasManyMapping:[self phoneMapping] forKey:@"phones"];
        mapping.primaryKey = @"personID";
    }];
}

+ (EKManagedObjectMapping *)personWithOnlyValueBlockMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedPerson class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromDictionary:@{ @"id": @"personID" }];
        [mapping mapFieldsFromArray:@[@"name", @"email", @"gender"]];
        mapping.primaryKey = @"personID";
    }];
}

+(EKManagedObjectMapping *)complexPlaneMapping
{
    EKManagedObjectMapping * mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Plane"];
    [mapping hasOneMapping:[self personMapping] forKey:@"captain"];
    [mapping hasManyMapping:[self personMapping] forKey:@"persons"];
    return mapping;
}

@end
