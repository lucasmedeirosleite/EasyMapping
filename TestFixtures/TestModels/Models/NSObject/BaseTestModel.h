//
//  BaseTestModel.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKMappingProtocol.h"
#import "EKObjectMapping.h"

@interface BaseTestModel : NSObject <EKMappingProtocol>

+(void)registerMapping:(EKObjectMapping *)objectMapping;

@end
