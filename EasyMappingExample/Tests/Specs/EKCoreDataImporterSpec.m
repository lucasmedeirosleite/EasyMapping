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
@property (nonatomic, strong) NSMutableDictionary * existingEntities;
@end

SPEC_BEGIN(EKCoreDataImporterSpec)

describe(@"EKCoreDataImporter", ^{
    
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

SPEC_END