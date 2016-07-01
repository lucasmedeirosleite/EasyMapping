//
//  EKObjectModel.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKMappingProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 EKModel is convenience base class, that allows transforming JSON objects to NSObjects and vice versa.
*/
@interface EKObjectModel : NSObject <EKMappingProtocol>

/**
 Create object using provided JSON dictionary. This method uses EKObjectMapping object, provided by objectMapping method of EKMappingProtocol.
 
 @param properties parsed JSON NSDictionary.
 
 @return mapped object
 */
+ (instancetype)objectWithProperties:(NSDictionary *)properties;


/**
 Create object using provided JSON dictionary. This method uses EKObjectMapping object, provided by objectMapping method of EKMappingProtocol.
 
 @param properties parsed JSON NSDictionary.
 
 @return mapped object
 */
- (instancetype)initWithProperties:(NSDictionary *)properties;

/**
 Serialize mapped object back to JSON representation. 
 
 @return NSDictionary representation of current object.
 */
- (NSDictionary *)serializedObject;

@end

NS_ASSUME_NONNULL_END