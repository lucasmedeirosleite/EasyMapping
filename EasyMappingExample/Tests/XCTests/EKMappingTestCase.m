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

@interface EKMappingTestCase : XCTestCase

@end

@implementation EKMappingTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimpleMapping
{
    NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Car"];
    
    [Car registerMapping:[MappingProvider carMapping]];

    Car *expectedCar = [Car new];
    expectedCar.carId = [[externalRepresentation valueForKey:@"id"] integerValue];
    expectedCar.model = [externalRepresentation valueForKey:@"model"];
    expectedCar.year = [externalRepresentation valueForKey:@"year"];

    [self testMapping:[Car objectMapping] withRepresentation:externalRepresentation expectedObject:expectedCar];
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
    
    [self testMapping:[Person objectMapping] withRepresentation:externalRepresentation expectedObject:expectedPerson];
}

- (void)testSimpleSerialization
{
    NSDictionary *expectedExternalRepresentation = [CMFixture buildUsingFixture:@"Car"];
    
    [Car registerMapping:[MappingProvider carMapping]];
    
    Car *car = [Car new];
    car.carId = [[expectedExternalRepresentation valueForKey:@"id"] integerValue];
    car.model = [expectedExternalRepresentation valueForKey:@"model"];
    car.year = [expectedExternalRepresentation valueForKey:@"year"];
    
    [self testSerializationUsingMapping:[Car objectMapping] withObject:car expectedRepresentation:expectedExternalRepresentation];
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
    
    [self testSerializationUsingMapping:[Person objectMapping] withObject:person expectedRepresentation:expectedExternalRepresentation];
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
    
    [self testSerializationUsingMapping:[Person objectMapping] withObject:person expectedRepresentation:expectedExternalRepresentation skippingKeyPaths:@[@"phones"]];
}

@end
