//
//  Three.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EKCoreDataModel.h"

@class One;

@interface Three : EKCoreDataModel

@property (nonatomic, strong) One * one;
@property (nonatomic, strong) NSArray * twos;

@end
