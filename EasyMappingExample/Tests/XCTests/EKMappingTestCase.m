//
//  EKMappingTestCase.m
//  EasyMappingExample
//
//  Created by Ilya Puchka on 14.01.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappingProvider.h"
#import "CMFixture.h"
#import "XCTestCase+EasyMapping.h"
#import "Car.h"
#import "Person.h"
#import "Phone.h"

@interface EKMappingTestCase : XCTestCase

@end

@implementation EKMappingTestCase

- (void)testSimpleMapping
{
    NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Car"];
    
    [Car registerMapping:[MappingProvider carMapping]];

    Car *expectedCar = [Car new];
    expectedCar.carId = [[externalRepresentation valueForKey:@"id"] integerValue];
    expectedCar.model = [externalRepresentation valueForKey:@"model"];
    expectedCar.year = [externalRepresentation valueForKey:@"year"];

    [self testObjectFromExternalRepresentation:externalRepresentation withMapping:[Car objectMapping] expectedObject:expectedCar];
}

- (void)testNonNestedMapping
{
    NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonNonNested"];

    [Person registerMapping:[MappingProvider personNonNestedMapping]];
    Person *expectedPerson = [Person new];
    Car *car = [Car new];
    car.carId = [[externalRepresentation valueForKey:@"carId"] integerValue];
    car.model = [externalRepresentation valueForKey:@"carModel"];
    car.year = [externalRepresentation valueForKey:@"carYear"];
    expectedPerson.car = car;
    expectedPerson.name = [externalRepresentation valueForKey:@"name"];
    expectedPerson.email = [externalRepresentation valueForKey:@"email"];
    NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
    expectedPerson.gender = (Gender)[genders[[externalRepresentation valueForKey:@"gender"]] integerValue];
    
    [self testObjectFromExternalRepresentation:externalRepresentation withMapping:[Person objectMapping] expectedObject:expectedPerson];
}

- (void)testSimpleSerialization
{
    NSDictionary *expectedExternalRepresentation = [CMFixture buildUsingFixture:@"Car"];
    
    [Car registerMapping:[MappingProvider carMapping]];
    
    Car *car = [Car new];
    car.carId = [[expectedExternalRepresentation valueForKey:@"id"] integerValue];
    car.model = [expectedExternalRepresentation valueForKey:@"model"];
    car.year = [expectedExternalRepresentation valueForKey:@"year"];
    
    [self testSerializeObject:car withMapping:[Car objectMapping] expectedRepresentation:expectedExternalRepresentation];
}

- (void)testNonNestedSerialization
{
    NSDictionary *expectedExternalRepresentation = [CMFixture buildUsingFixture:@"PersonNonNested"];
    
    [Person registerMapping:[MappingProvider personNonNestedMapping]];
    Person *person = [Person new];
    Car *car = [Car new];
    car.carId = [[expectedExternalRepresentation valueForKey:@"carId"] integerValue];
    car.model = [expectedExternalRepresentation valueForKey:@"carModel"];
    car.year = [expectedExternalRepresentation valueForKey:@"carYear"];
    person.car = car;
    person.name = [expectedExternalRepresentation valueForKey:@"name"];
    person.email = [expectedExternalRepresentation valueForKey:@"email"];
    NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
    person.gender = (Gender)[genders[[expectedExternalRepresentation valueForKey:@"gender"]] integerValue];
    
    [self testSerializeObject:person withMapping:[Person objectMapping] expectedRepresentation:expectedExternalRepresentation];
}

- (void)testNestedSerialization
{
    NSDictionary *expectedExternalRepresentation = [CMFixture buildUsingFixture:@"Person"];
    
    [Person registerMapping:[MappingProvider personMapping]];
    [Car registerMapping:[MappingProvider carMapping]];
    Person *person = [Person new];
    Car *car = [Car new];
    car.carId = [[expectedExternalRepresentation valueForKeyPath:@"car.id"] integerValue];
    car.model = [expectedExternalRepresentation valueForKeyPath:@"car.model"];
    car.year = [expectedExternalRepresentation valueForKeyPath:@"car.year"];
    person.car = car;
    person.name = [expectedExternalRepresentation valueForKey:@"name"];
    person.email = [expectedExternalRepresentation valueForKey:@"email"];
    NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
    person.gender = (Gender)[genders[[expectedExternalRepresentation valueForKey:@"gender"]] integerValue];
    
    [self testSerializeObject:person withMapping:[Person objectMapping] expectedRepresentation:expectedExternalRepresentation skippingKeyPaths:@[@"phones",@"socialURL"]];
}

- (void)testIgnoreMissingFieldsProperty
{
    NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
    NSDictionary *externalRepresentationPartial = [CMFixture buildUsingFixture:@"PersonWithoutRelations"];
    
    [Person registerMapping:[MappingProvider personMapping]];
    [Car registerMapping:[MappingProvider carMapping]];
    [Phone registerMapping:[MappingProvider phoneMapping]];
    EKObjectMapping *personMapping = [Person objectMapping];
    
    Person *person = [EKMapper objectFromExternalRepresentation:externalRepresentation
                                                    withMapping:personMapping];
    
    // Check default behaviour
    XCTAssertNotNil(person.car);
    XCTAssertNotNil(person.phones);
    [EKMapper fillObject:person fromExternalRepresentation:externalRepresentationPartial withMapping:personMapping];
    XCTAssertNil(person.car);
    XCTAssertNil(person.phones);
    
    // Check behaviour with set ignoreMissingFields property
    person = [EKMapper objectFromExternalRepresentation:externalRepresentation
                                            withMapping:personMapping];
    
    personMapping.ignoreMissingFields = YES;
    XCTAssertNotNil(person.car);
    XCTAssertNotNil(person.phones);
    [EKMapper fillObject:person fromExternalRepresentation:externalRepresentationPartial withMapping:personMapping];
    XCTAssertNotNil(person.car);
    XCTAssertNotNil(person.phones);
}

- (void) testIgnoreMissingFieldsWorksForProperties {
    NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
    
    [Person registerMapping:[MappingProvider personMappingThatAssertsOnNilInValueBlock]];
    [Car registerMapping:[MappingProvider carMapping]];
    [Phone registerMapping:[MappingProvider phoneMapping]];
    EKObjectMapping *personMapping = [Person objectMapping];
    
    Person *person = [EKMapper objectFromExternalRepresentation:externalRepresentation
                                                    withMapping:personMapping];
    
    personMapping.ignoreMissingFields = YES;
    XCTAssertNotNil(person.car);
    XCTAssertNotNil(person.phones);
    [EKMapper fillObject:person fromExternalRepresentation:@{@"id":@23,@"name":@"Lucas"} withMapping:personMapping];
    XCTAssert(person.gender == GenderMale);
    XCTAssert([person.socialURL.absoluteString isEqual:@"https://www.twitter.com/EasyMapping"]);
}

@end
