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

@interface EKCoreDataImporter()
@property (nonatomic, strong) NSSet * entityNames;
@property (nonatomic, strong) NSMutableDictionary * existingEntitiesPrimaryKeys;
@end

SPEC_BEGIN(EKCoreDataImporterSpec)

describe(@"Entity names collector", ^{
    
    it(@"should collect entities from nested mapping", ^{
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
        [mapping hasOneMapping:[ManagedMappingProvider carWithRootKeyMapping]
                        forKey:@"car"];
        [mapping hasOneMapping:[ManagedMappingProvider phoneMapping]
                        forKey:@"phone"];
        EKManagedObjectMapping * fingerMapping = [EKManagedObjectMapping mappingForEntityName:@"Finger" withBlock:nil];
        [mapping hasManyMapping:fingerMapping forKey:@"fingers"];
        EKManagedObjectMapping * addressMapping = [EKManagedObjectMapping mappingForEntityName:@"Address" withBlock:^(EKManagedObjectMapping *addressMapping) {
            [addressMapping hasOneMapping:[EKManagedObjectMapping mappingForEntityName:@"Alien" withBlock:nil] forKey:@"alien"];
            [addressMapping hasManyMapping:[EKManagedObjectMapping mappingForEntityName:@"Ufo" withBlock:nil] forKey:@"ufos"];
            [addressMapping hasOneMapping:[ManagedMappingProvider personMapping] forKey:@"postman"];
        }];
        [mapping hasManyMapping:addressMapping forKey:@"addressBook"];
        
        EKCoreDataImporter * importer = [EKCoreDataImporter importerWithMapping:mapping
                                                         externalRepresentation:nil
                                                                        context:nil];
        
        [[importer.entityNames should] equal:[NSSet setWithArray:@[@"ManagedPerson",@"ManagedCar",@"ManagedPhone", @"Address", @"Alien",@"Ufo",@"Finger"]]];
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
        importer = [EKCoreDataImporter importerWithMapping:[ManagedMappingProvider complexPlaneMapping] externalRepresentation:externalRepresentation context:nil];
        
        NSSet * cars = [NSSet setWithObjects:@3,@8, nil];
        NSSet * people = [NSSet setWithObjects:@3,@17,@89, nil];
        NSSet * phones = [NSSet setWithObjects:@1,@2,@4,@5, nil];
        
        [[importer.existingEntitiesPrimaryKeys should] equal:@{@"ManagedCar":cars,
                                                               @"ManagedPerson":people,
                                                               @"ManagedPhone":phones,
                                                               @"Plane":[NSSet set]}];
    });
    
});

SPEC_END