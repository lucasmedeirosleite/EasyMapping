//
//  EKModel.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKMappingProtocol.h"

@interface EKModel : NSObject <EKMappingProtocol>

+ (instancetype)objectWithProperties:(NSDictionary *)properties;

- (instancetype)initWithProperties:(NSDictionary *)properties;

- (NSDictionary *)serializedObject;

@end
