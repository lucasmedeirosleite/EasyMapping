//
//  EKCoreDataImportBenchmarkSuite.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 10.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKCoreDataImportBenchmarkSuite.h"
#import "EKMapper.h"
#import "ManagedMappingProvider.h"
#import "EKCoreDataManager.h"
#import "EKManagedObjectMapper.h"

@implementation EKCoreDataImportBenchmarkSuite

+(instancetype)suite
{
    EKCoreDataImportBenchmarkSuite * suite = [self new];
    suite.fixtureName = @"CoreData import";
    return suite;
}

-(NSArray *)generateImportData:(NSInteger)howMany
{
    NSMutableArray *output = [NSMutableArray array];
	for (NSUInteger index = 0; index < howMany; index++) {
		NSDictionary *person = @{
                                 @"id": @(index),
                                 @"name": [NSString stringWithFormat:@"name %ld", (long)index],
                                 @"email": [NSString stringWithFormat:@"%ld@email.com", (long)index],
                                 @"phones": @[
                                         @{
                                             @"id": @(index * 5 + 0),
                                             @"number": @"11111",
                                             @"ddi": @"ddivalue",
                                             @"ddd": @"dddvalue",
                                             },
                                         @{
                                             @"id": @(index * 5 + 1),
                                             @"number": @"11111",
                                             @"ddi": @"ddivalue",
                                             @"ddd": @"dddvalue",
                                             },
                                         @{
                                             @"id": @(index * 5 + 2),
                                             @"number": @"11111",
                                             @"ddi": @"ddivalue",
                                             @"ddd": @"dddvalue",
                                             },
                                         @{
                                             @"id": @(index * 5 + 3),
                                             @"number": @"11111",
                                             @"ddi": @"ddivalue",
                                             @"ddd": @"dddvalue",
                                             },
                                         @{
                                             @"id": @(index * 5 + 4),
                                             @"number": @"11111",
                                             @"ddi": @"ddivalue",
                                             @"ddd": @"dddvalue",
                                             },
                                         ],
                                 };
        
		[output addObject:person];
	}
    return output;
}

-(NSTimeInterval)runTimes:(NSInteger)howManyTimes
{
    [[EKCoreDataManager sharedInstance] deleteAllObjectsInCoreData];
    NSArray * objects = [self generateImportData:howManyTimes];
    
    NSDate * start = [NSDate date];
    [EKManagedObjectMapper arrayOfObjectsFromExternalRepresentation:objects
                                           withMapping:[ManagedMappingProvider personWithPhonesMapping]
                                inManagedObjectContext:[[EKCoreDataManager sharedInstance] managedObjectContext]];
    
    return [[NSDate date] timeIntervalSinceDate:start];
}

@end
