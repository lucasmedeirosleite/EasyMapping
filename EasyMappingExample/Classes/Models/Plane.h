//
//  Plane.h
//  EasyMappingExample
//
//  Created by Dany L'Hebreux on 2013-10-03.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "BaseTestModel.h"

@interface Plane : BaseTestModel

@property (nonatomic, strong) NSNumber *flightNumber;
@property (nonatomic, strong) NSSet *persons;
@property (nonatomic, strong) NSMutableSet *pilots;
@property (nonatomic, strong) NSOrderedSet *stewardess;
@property (nonatomic, strong) NSMutableOrderedSet *stars;

@end

@interface Seaplane : BaseTestModel

@property (nonatomic, strong) NSNumber *flightNumber;
@property (nonatomic, strong) NSSet *passengers;

@end
