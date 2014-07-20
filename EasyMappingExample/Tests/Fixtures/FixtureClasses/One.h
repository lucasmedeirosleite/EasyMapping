//
//  One.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Two.h"
#import "EKManagedObjectModel.h"

@interface One : EKManagedObjectModel

@property (nonatomic, strong) Two * two;

@end
