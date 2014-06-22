//
//  Seaplane.h
//  EasyMappingExample
//
//  Created by Dany L'Hebreux on 2013-10-31.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTestModel.h"

@interface Seaplane : BaseTestModel

@property (nonatomic, strong) NSNumber *flightNumber;
@property (nonatomic, strong) NSSet *passengers;

@end
