//
//  EKCoreDataImporter.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 10.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKManagedObjectMapping.h"

@interface EKCoreDataImporter : NSObject

@property (nonatomic, strong) NSManagedObjectContext * context;
@property (nonatomic, strong) EKManagedObjectMapping * mapping;
@property (nonatomic, strong) id externalRepresentation;

+(instancetype)importerWithMapping:(EKManagedObjectMapping *)mapping
            externalRepresentation:(id)externalRepresentation
                           context:(NSManagedObjectContext *)context;

-(id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                          withMapping:(EKManagedObjectMapping *)mapping;

-(id)           fillObject:(id)object
fromExternalRepresentation:(NSDictionary *)externalRepresentation
               withMapping:(EKManagedObjectMapping *)mapping;

-(NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                         withMapping:(EKManagedObjectMapping *)mapping;
@end
