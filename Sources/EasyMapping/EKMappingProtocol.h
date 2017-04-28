//
//  EKMappingProtocol.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKObjectMapping.h"
#import "EKManagedObjectMapping.h"

NS_ASSUME_NONNULL_BEGIN

/**
 EKMappingProtocol must be implemented by NSObject subclasses, that will be mapped from JSON representation.
 
 EasyMapping provides convenience EKObjectModel class, that already implements this protocol.
 */
@protocol EKMappingProtocol

/**
 EKObjectMapping instance, that will be used in mapping process.
 
 @return object mapping
 */
+(EKObjectMapping *)objectMapping;

@end

/**
 EKManagedMappingProtocol must be implemented by NSManagedObject subclasses, that will be mapped from JSON representation.
 
 EasyMapping provides convenience EKManagedObjectModel class, that already implements this protocol.
 */
@protocol EKManagedMappingProtocol

/**
 EKManagedObjectMapping instance, that will be used in mapping process.
 
 @return object mapping
 */
+(EKManagedObjectMapping *)objectMapping;

@end

NS_ASSUME_NONNULL_END