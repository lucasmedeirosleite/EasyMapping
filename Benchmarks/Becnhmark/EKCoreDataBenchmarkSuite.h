//
//  EKCoreDataBenchmarkSuite.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 04.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKBenchmarkSuite.h"
#import "EKManagedObjectMapping.h"

@interface EKCoreDataBenchmarkSuite : EKBenchmarkSuite

@property (nonatomic, strong) EKManagedObjectMapping * mapping;

@end
