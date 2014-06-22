//
//  Person.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTestModel.h"

@class Car;

typedef enum {
    GenderMale,
    GenderFemale
} Gender;

@interface Person : BaseTestModel

@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *email;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, strong) Car *car;
@property (nonatomic, strong) NSArray *phones;
@property (nonatomic, strong) Person * relative;
@property (nonatomic, strong) NSArray* children;

@end
