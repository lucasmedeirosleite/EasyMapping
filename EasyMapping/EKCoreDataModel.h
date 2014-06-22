//
//  EKCoreDataModel.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EKMappingProtocol.h"

@interface EKCoreDataModel : NSManagedObject <EKManagedMappingProtocol>

+(instancetype)objectWithProperties:(NSDictionary *)properties
                          inContext:(NSManagedObjectContext *)context;

- (NSDictionary *)serializedObject;

@end
