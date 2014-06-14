//
//  EKRelationshipMapping.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 14.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKObjectMapping.h"

@interface EKRelationshipMapping : NSObject

@property (nonatomic, strong) EKObjectMapping * objectMapping;

@property (nonatomic, strong) NSString * sourceKeyPath;

@property (nonatomic, strong) NSString * destinationProperty;

@end
