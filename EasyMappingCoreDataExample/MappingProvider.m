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

@implementation MappingProvider

+ (EKManagedObjectMapping *)carMapping
{
    return [EKManagedObjectMapping mappingForEntityName:@"Car" withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"model", @"year"]];
    }];
}

+ (EKManagedObjectMapping *)carWithRootKeyMapping
{
    return [EKManagedObjectMapping mappingForEntityName:@"Car" withRootPath:@"car" withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"model", @"year"]];
    }];
}

+ (EKManagedObjectMapping *)carNestedAttributesMapping
{
    return [EKManagedObjectMapping mappingForEntityName:@"Car" withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"model"]];
        [mapping mapFieldsFromDictionary:@{
            @"information.year" : @"year"
        }];
    }];
}

+ (EKManagedObjectMapping *)carWithDateMapping
{
    return [EKManagedObjectMapping mappingForEntityName:@"Car" withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"model", @"year"]];
        [mapping mapKey:@"created_at" toField:@"createdAt" withDateFormat:@"yyyy-MM-dd"];
    }];
}

+ (EKManagedObjectMapping *)phoneMapping
{
    return [EKManagedObjectMapping mappingForEntityName:@"Phone" withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"number"]];
        [mapping mapFieldsFromDictionary:@{
            @"ddi" : @"ddi",
            @"ddd" : @"ddd"
         }];
    }];
}

+ (EKManagedObjectMapping *)personMapping
{
    return [EKManagedObjectMapping mappingForEntityName:@"Person" withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"name", @"email", @"gender"]];
        [mapping hasOneMapping:[self carMapping] forKey:@"car"];
        [mapping hasManyMapping:[self phoneMapping] forKey:@"phones"];
    }];
}

+ (EKManagedObjectMapping *)personWithCarMapping
{
    return [EKManagedObjectMapping mappingForEntityName:@"Person" withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping hasOneMapping:[self carMapping] forKey:@"car"];
    }];
}

+ (EKManagedObjectMapping *)personWithPhonesMapping
{
    return [EKManagedObjectMapping mappingForEntityName:@"Person" withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping hasManyMapping:[self phoneMapping] forKey:@"phones"];
    }];
}

+ (EKManagedObjectMapping *)personWithOnlyValueBlockMapping
{
    return [EKManagedObjectMapping mappingForEntityName:@"Person" withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"name", @"email", @"gender"]];
    }];
}

@end
