//
//  One.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Two.h"
#import "EKCoreDataModel.h"

@interface One : EKCoreDataModel

@property (nonatomic, strong) Two * two;

@end
