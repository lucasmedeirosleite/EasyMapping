//
//  BaseManagedTestModel.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EKManagedObjectMapping.h"
#import "EKMappingProtocol.h"

@interface BaseManagedTestModel : NSManagedObject <EKManagedMappingProtocol>

+(void)registerMapping:(EKManagedObjectMapping *)objectMapping;

@end
