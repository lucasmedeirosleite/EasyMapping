//
//  EKCoreDataImporterSpec.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 10.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EKCoreDataImporter.h"
#import "ManagedMappingProvider.h"
#import "CMFixture.h"
#import "ManagedCar.h"
#import "ManagedPhone.h"
#import "ManagedPerson.h"
#import "Alien.h"
#import "UFO.h"
#import "ColoredUFO.h"
#import "Finger.h"
#import "MappingProvider.h"
#import "Address.h"
#import "Plane.h"

@interface EKCoreDataImporter()
@property (nonatomic, strong) NSSet * entityNames;
@property (nonatomic, strong) NSMutableDictionary * existingEntitiesPrimaryKeys;
@end

SPEC_BEGIN(EKCoreDataImporterSpec)

describe(@"Entity names collector", ^{
    
    afterAll(^{
        [ManagedPerson registerMapping:[ManagedMappingProvider personMapping]];
    });
    
    it(@"should collect entities from nested mapping", ^{
        [ManagedPerson registerMapping:[ManagedMappingProvider personMapping]];
        [ManagedCar registerMapping:[ManagedMappingProvider carMapping]];
        [ManagedPhone registerMapping:[ManagedMappingProvider phoneMapping]];
        EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:[ManagedMappingProvider personMapping]
                                                         externalRepresentation:nil
                                                                        context:nil];
        
        [[importer.entityNames should] equal:[NSSet setWithArray:@[@"ManagedPerson",@"ManagedCar",@"ManagedPhone"]]];
    });
    
    it(@"should collect entities with root key", ^{
        EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:[ManagedMappingProvider carWithRootKeyMapping]
                                                         externalRepresentation:nil
                                                                        context:nil];
        
        [[importer.entityNames should] equal:[NSSet setWithArray:@[@"ManagedCar"]]];
    });
    
    it(@"should collect entities with complex structure", ^{
        EKManagedObjectMapping * mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"ManagedPerson"];
        [ManagedCar registerMapping:[ManagedMappingProvider carWithRootKeyMapping]];
        [ManagedPhone registerMapping:[ManagedMappingProvider phoneMapping]];
        [Finger registerMapping:[MappingProvider fingerMapping]];
        [mapping hasOne:[ManagedCar class] forKeyPath:@"car"];
        [mapping hasOne:[ManagedPhone class] forKeyPath:@"phone"];
        EKManagedObjectMapping * addressMapping = [EKManagedObjectMapping mappingForEntityName:@"Address" withBlock:^(EKManagedObjectMapping *addressMapping) {
            [addressMapping hasOne:[ManagedPerson class] forKeyPath:@"postman"];
        }];
        [Address registerMapping:addressMapping];
        [mapping hasOne:[Address class] forKeyPath:@"addressBook"];
        
        EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:mapping
                                                         externalRepresentation:nil
                                                                        context:nil];
        
        [[importer.entityNames should] equal:[NSSet setWithArray:@[@"ManagedPerson",@"ManagedCar",@"ManagedPhone", @"Address"]]];
    });
});

describe(@"Entities introspection", ^{
   
    __block NSDictionary *externalRepresentation = nil;
    __block EKCoreDataImporter * importer = nil;
    
    beforeEach(^{
        externalRepresentation = nil;
        importer = nil;
    });
    
    it(@"should collect entities with root keyPath", ^{
        externalRepresentation = [CMFixture buildUsingFixture:@"CarWithRoot"];
       
        importer = [EKCoreDataImporter importerWithMapping:[ManagedMappingProvider carWithRootKeyMapping] externalRepresentation:externalRepresentation context:nil];
        
        NSSet * values = [NSSet setWithObject:@1];
        
        [[importer.existingEntitiesPrimaryKeys should] equal:@{@"ManagedCar":values}];
    });
    
    it(@"should collect entities from array of objects", ^{
        externalRepresentation = [CMFixture buildUsingFixture:@"Cars"];
        
        importer = [EKCoreDataImporter importerWithMapping:[ManagedMappingProvider carMapping] externalRepresentation:externalRepresentation context:nil];
        
        NSSet * values = [NSSet setWithObjects:@1,@2, nil];
        
        [[importer.existingEntitiesPrimaryKeys should] equal:@{@"ManagedCar":values}];
    });
    
    it(@"should collect entities from hasOne and hasMany relationships", ^{
        externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
        
        [ManagedCar registerMapping:[ManagedMappingProvider carMapping]];
        importer = [EKCoreDataImporter importerWithMapping:[ManagedMappingProvider personMapping] externalRepresentation:externalRepresentation context:nil];
        
        NSSet * cars = [NSSet setWithObject:@3];
        NSSet * people = [NSSet setWithObject:@23];
        NSSet * phones = [NSSet setWithObjects:@1,@2, nil];
        
        [[importer.existingEntitiesPrimaryKeys should] equal:@{@"ManagedCar":cars,
                                                               @"ManagedPerson":people,
                                                               @"ManagedPhone":phones}];
    });
    
    it(@"should collect entities recursively", ^{
        externalRepresentation = [CMFixture buildUsingFixture:@"ComplexRepresentation"];
        [Plane registerMapping:[ManagedMappingProvider complexPlaneMapping]];
        importer = [EKCoreDataImporter importerWithMapping:[ManagedMappingProvider complexPlaneMapping] externalRepresentation:externalRepresentation context:nil];
        
        NSSet * cars = [NSSet setWithObjects:@3,@8, nil];
        NSSet * people = [NSSet setWithObjects:@3,@17,@89, nil];
        NSSet * phones = [NSSet setWithObjects:@1,@2,@4,@5, nil];
        
        [[importer.existingEntitiesPrimaryKeys should] equal:@{@"ManagedCar":cars,
                                                               @"ManagedPerson":people,
                                                               @"ManagedPhone":phones,
                                                               @"Plane":[NSSet set]}];
    });
    
    it(@"should collect entities when hasOneMapping has null", ^{
       
        externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithNullCar"];
        importer = [EKCoreDataImporter importerWithMapping:[ManagedMappingProvider personMapping] externalRepresentation:externalRepresentation context:nil];
        
        NSSet * cars = [NSSet set];
        NSSet * people = [NSSet setWithObject:@5];
        NSSet * phones = [NSSet setWithObjects:@6,@7,nil];
        
        [[importer.existingEntitiesPrimaryKeys should] equal:@{@"ManagedCar":cars,
                                                               @"ManagedPerson":people,
                                                               @"ManagedPhone":phones}];
    });
    
    it(@"should collect entities when hasManyMapping has null", ^{
        externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithNullPhones"];
        importer = [EKCoreDataImporter importerWithMapping:[ManagedMappingProvider personMapping] externalRepresentation:externalRepresentation context:nil];
        
        NSSet * cars = [NSSet setWithObject:@56];
        NSSet * people = [NSSet set];
        NSSet * phones = [NSSet set];
        
        [[importer.existingEntitiesPrimaryKeys should] equal:@{@"ManagedCar":cars,
                                                               @"ManagedPerson":people,
                                                               @"ManagedPhone":phones}];
    });
    
});

SPEC_END