//
//  One.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "EKManagedObjectModel.h"

@class Two;
@class Three;

@interface One : EKManagedObjectModel

@property (nonatomic, strong) Two * two;

@end

@interface Two : EKManagedObjectModel

@property (nonatomic, strong) Three * three;

@end

@interface Three : EKManagedObjectModel

@property (nonatomic, strong) One * one;
@property (nonatomic, strong) NSArray * twos;

@end
