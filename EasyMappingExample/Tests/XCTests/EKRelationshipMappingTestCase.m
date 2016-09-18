//
//  EKRelationshipMappingTestCase.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 18.09.16.
//  Copyright © 2016 EasyKit. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Dog.h"
#import "Wolf.h"
#import "MappingProvider.h"
#import "CMFixture.h"
#import "XCTestCase+EasyMapping.h"
#import "Car.h"
#import "Person.h"
#import "Phone.h"
#import "EKObjectModel.h"
#import <EasyMapping/EasyMapping.h>

@interface EKRelationshipMappingTestCase : XCTestCase

@end

@implementation EKRelationshipMappingTestCase

-(void)testPersonMappingIncludesAnimals
{
    NSDictionary * representation = [CMFixture buildUsingFixture:@"PersonWithAnimals"];
    Person * person = [EKMapper objectFromExternalRepresentation:representation withMapping:[MappingProvider personWithPetsMapping]];
    
    XCTAssertEqual(person.pets.count,4);
    Dog * dog = person.pets.firstObject;
    XCTAssert([dog.family isEqualToString:@"Macintosh"]);
    Wolf * wolf = person.pets.lastObject;
    XCTAssert([wolf.pack isEqualToString:@"Bronzebeard"]);
}

@end
