//
//  MappingProvider.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"
#import "EKObjectMapping.h"

NS_ASSUME_NONNULL_BEGIN

@interface ManagedMappingProvider : NSObject

+ (EKObjectMapping *)carMapping;
+ (EKObjectMapping *)carWithRootKeyMapping;
+ (EKObjectMapping *)carNestedAttributesMapping;
+ (EKObjectMapping *)carWithDateMapping;
+ (EKObjectMapping *)phoneMapping;
+ (EKObjectMapping *)personNonNestedMapping;
+ (EKObjectMapping *)personMapping;
+ (EKObjectMapping *)personWithCarMapping;
+ (EKObjectMapping *)personWithOnlyValueBlockMapping;
+ (EKObjectMapping *)personWithPhonesMapping;
+ (EKObjectMapping *)personWithReverseBlocksMapping;

// Fake mapping, is not backed up by CoreData model
+ (EKObjectMapping *)complexPlaneMapping;

+ (NSDateFormatter *)iso8601DateFormatter;

@end

NS_ASSUME_NONNULL_END
