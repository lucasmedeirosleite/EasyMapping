//
//  EKMappingProtocol.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 22.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKObjectMapping.h"
#import "EKManagedObjectMapping.h"

@protocol EKMappingProtocol <NSObject>

+(EKObjectMapping *)objectMapping;

@end

@protocol EKManagedMappingProtocol <NSObject>

+(EKManagedObjectMapping *)objectMapping;

@end
