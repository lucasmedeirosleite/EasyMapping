//
//  UFO.h
//  EasyMappingExample
//
//  Created by Jack Shurpin on 4/1/14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTestModel.h"
#import "Alien.h"

@interface UFO : BaseTestModel

@property (nonatomic, strong) NSString *shape;
@property (nonatomic, strong) Alien *captain;
@property (nonatomic, strong) NSMutableArray *crew;


@end
