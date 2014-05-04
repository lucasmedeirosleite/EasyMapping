//
//  EKCoreDataBenchmarkSuite.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 04.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKCoreDataBenchmarkSuite.h"
#import "EKMapper.h"
#import "EKCoreDataManager.h"

@implementation EKCoreDataBenchmarkSuite

-(void)runSingleSuite
{
    [EKMapper objectFromExternalRepresentation:[self externalRepresentation]
                                   withMapping:self.mapping
                        inManagedObjectContext:[[EKCoreDataManager sharedInstance] managedObjectContext]];
    [[[EKCoreDataManager sharedInstance]managedObjectContext] save:nil];
}

-(NSTimeInterval)runTimes:(NSInteger)howManyTimes
{
    [[EKCoreDataManager sharedInstance] deleteAllObjectsInCoreData];
    
    return [super runTimes:howManyTimes];
}

@end
