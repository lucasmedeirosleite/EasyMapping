//
//  MappingProvider.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"
#import "EKManagedObjectMapping.h"

NS_ASSUME_NONNULL_BEGIN

@interface ManagedMappingProvider : NSObject

+ (EKManagedObjectMapping *)carMapping;
+ (EKManagedObjectMapping *)carWithRootKeyMapping;
+ (EKManagedObjectMapping *)carNestedAttributesMapping;
+ (EKManagedObjectMapping *)carWithDateMapping;
+ (EKManagedObjectMapping *)phoneMapping;
+ (EKManagedObjectMapping *)personNonNestedMapping;
+ (EKManagedObjectMapping *)personMapping;
+ (EKManagedObjectMapping *)personWithCarMapping;
+ (EKManagedObjectMapping *)personWithOnlyValueBlockMapping;
+ (EKManagedObjectMapping *)personWithPhonesMapping;
+ (EKManagedObjectMapping *)personWithReverseBlocksMapping;

// Fake mapping, is not backed up by CoreData model
+ (EKManagedObjectMapping *)complexPlaneMapping;

+ (NSDateFormatter *)iso8601DateFormatter;

@end

NS_ASSUME_NONNULL_END
