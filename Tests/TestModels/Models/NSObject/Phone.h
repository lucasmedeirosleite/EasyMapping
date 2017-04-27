//
//  Phone.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTestModel.h"

@interface Phone : BaseTestModel

@property (nonatomic, copy) NSString *DDI;
@property (nonatomic, copy) NSString *DDD;
@property (nonatomic, copy) NSString *number;

@end
