//
//  EKBlocks.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^EKMappingValueBlock)(NSString *key, id value);
typedef id(^EKMappingReverseBlock)(id value);
