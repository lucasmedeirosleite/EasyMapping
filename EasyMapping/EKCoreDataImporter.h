//
//  EKCoreDataImporter.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 10.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKManagedObjectMapping.h"
#import <CoreData/CoreData.h>

@interface EKCoreDataImporter : NSObject

@property (nonatomic, strong) NSManagedObjectContext * context;
@property (nonatomic, strong) EKManagedObjectMapping * mapping;
@property (nonatomic, strong) id externalRepresentation;

+ (instancetype)importerWithMapping:(EKManagedObjectMapping *)mapping
            externalRepresentation:(id)externalRepresentation
                           context:(NSManagedObjectContext *)context;

- (id)existingObjectForRepresentation:(id)representation mapping:(EKManagedObjectMapping *)mapping;

@end
