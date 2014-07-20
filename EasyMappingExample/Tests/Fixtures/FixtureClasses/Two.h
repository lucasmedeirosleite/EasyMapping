//
//  Two.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Three.h"
#import "EKManagedObjectModel.h"

@interface Two : EKManagedObjectModel

@property (nonatomic, strong) Three * three;

@end
