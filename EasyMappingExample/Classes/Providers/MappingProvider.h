//
//  MappingProvider.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@interface MappingProvider : NSObject

+ (EKObjectMapping *)carMapping;
+ (EKObjectMapping *)carWithRootKeyMapping;
+ (EKObjectMapping *)carNestedAttributesMapping;
+ (EKObjectMapping *)carWithDateMapping;
+ (EKObjectMapping *)carWithCustomFormatDateMapping;
+ (EKObjectMapping *)phoneMapping;
+ (EKObjectMapping *)personNonNestedMapping;
+ (EKObjectMapping *)personMapping;
+ (EKObjectMapping *)personWithCarMapping;
+ (EKObjectMapping *)personWithOnlyValueBlockMapping;
+ (EKObjectMapping *)personWithPhonesMapping;
+ (EKObjectMapping *)personWithRelativeMapping;
+ (EKObjectMapping *)addressMapping;
+ (EKObjectMapping *)nativeMappingWithNullPropertie;

@end
