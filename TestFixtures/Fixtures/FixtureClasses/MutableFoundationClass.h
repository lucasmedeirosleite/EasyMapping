//
//  MutableFoundationClass.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 06.06.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKObjectModel.h"

@interface MutableFoundationClass : EKObjectModel

@property (nonatomic, strong) NSMutableArray * array;
@property (nonatomic, strong) NSMutableDictionary * dictionary;
@property (nonatomic, strong) NSSet * set;
@property (nonatomic, strong) NSMutableSet * mutableSet;
@property (nonatomic, strong) NSOrderedSet * orderedSet;
@property (nonatomic, strong) NSMutableOrderedSet * mutableOrderedSet;
@property (nonatomic, strong) id idObject;

@end
