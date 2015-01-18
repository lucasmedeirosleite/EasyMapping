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
        [mapping mapPropertiesFromDictionary:@{ @"id": @"carID" }];
        [mapping mapPropertiesFromArray:@[@"model", @"year"]];
        mapping.primaryKey = @"carID";
    }];
}

+ (EKManagedObjectMapping *)carWithRootKeyMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedCar class])
                                           withRootPath:@"car"
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{ @"id": @"carID" }];
        [mapping mapPropertiesFromArray:@[@"model", @"year"]];
        mapping.primaryKey = @"carID";
    }];
}

+ (EKManagedObjectMapping *)carNonNestedMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedCar class]) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"carId": @"carID",
                                               @"carModel":@"model",
                                               @"carYear":@"year"
                                               }];
        mapping.primaryKey = @"carID";
    }];
}

+ (EKManagedObjectMapping *)carNestedAttributesMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedCar class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{ @"id": @"carID" }];
        [mapping mapPropertiesFromArray:@[@"model"]];
        [mapping mapPropertiesFromDictionary:@{
            @"information.year" : @"year"
         }];
        mapping.primaryKey = @"carID";
    }];
}

+ (EKManagedObjectMapping *)carWithDateMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedCar class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{ @"id": @"carID" }];
        [mapping mapPropertiesFromArray:@[@"model", @"year"]];
        [mapping mapKeyPath:@"created_at" toProperty:@"createdAt" withDateFormat:@"yyyy-MM-dd"];
        mapping.primaryKey = @"carID";
    }];
}

+ (EKManagedObjectMapping *)phoneMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedPhone class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{ @"id": @"phoneID" }];
        [mapping mapPropertiesFromArray:@[@"number"]];
        [mapping mapPropertiesFromDictionary:@{
            @"ddi" : @"ddi",
            @"ddd" : @"ddd"
         }];
        mapping.primaryKey = @"phoneID";
    }];
}

+(EKManagedObjectMapping *)personNonNestedMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedPerson class]) withBlock:
            ^(EKManagedObjectMapping *mapping) {
      [mapping mapPropertiesFromArray:@[@"name", @"email", @"gender"]];
      
      [mapping hasOne:[ManagedCar class] forDictionaryFromKeyPaths:@[@"carId",@"carModel",@"carYear"]
          forProperty:@"car" withObjectMapping:[self carNonNestedMapping]];
                mapping.primaryKey = @"personID";
    }];
}

+ (EKManagedObjectMapping *)personMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedPerson class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{ @"id": @"personID" }];
        [mapping mapPropertiesFromArray:@[@"name", @"email", @"gender"]];
        [mapping hasOne:ManagedCar.class forKeyPath:@"car"];
        [mapping hasMany:ManagedPhone.class forKeyPath:@"phones"];
        mapping.primaryKey = @"personID";
    }];
}

+(EKManagedObjectMapping *)personWithReverseBlocksMapping
{
    EKManagedObjectMapping * personMapping = [self personWithCarMapping];
    [personMapping mapKeyPath:@"gender" toProperty:@"gender"
               withValueBlock:^id(NSString *key, id value, NSManagedObjectContext *context) {
                   if ([value isEqualToString:@"male"])
                   {
                       return @"husband";
                   }
                   else if ([value isEqualToString:@"female"])
                   {
                       return @"wife";
                   }
                   return nil;
               } reverseBlock:^id(id value, NSManagedObjectContext *context) {
                   if ([value isEqualToString:@"husband"])
                   {
                       return @"male";
                   }
                   else if ([value isEqualToString:@"wife"])
                   {
                       return @"female";
                   }
                   return nil;
               }];
    
    return personMapping;
}

+ (EKManagedObjectMapping *)personWithCarMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedPerson class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{ @"id": @"personID" }];
        [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        [mapping hasOne:[ManagedCar class] forKeyPath:@"car"];
        mapping.primaryKey = @"personID";
    }];
}

+ (EKManagedObjectMapping *)personWithPhonesMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedPerson class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{ @"id": @"personID" }];
        [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        [mapping hasMany:[ManagedPhone class] forKeyPath:@"phones"];
        mapping.primaryKey = @"personID";
    }];
}

+ (EKManagedObjectMapping *)personWithOnlyValueBlockMapping
{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([ManagedPerson class])
                                              withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{ @"id": @"personID" }];
        [mapping mapPropertiesFromArray:@[@"name", @"email", @"gender"]];
        mapping.primaryKey = @"personID";
    }];
}

+(EKManagedObjectMapping *)complexPlaneMapping
{
    EKManagedObjectMapping * mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Plane"];
    [mapping hasOne:[ManagedPerson class] forKeyPath:@"captain"];
    [mapping hasMany:[ManagedPerson class] forKeyPath:@"persons"];
    return mapping;
}

@end
