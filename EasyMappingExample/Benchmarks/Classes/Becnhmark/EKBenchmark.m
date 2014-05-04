//
//  EKBenchmark.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 04.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKBenchmark.h"
#import "EKBenchmarkSuite.h"
#import "MappingProvider.h"
#import "ManagedMappingProvider.h"
#import "EKCoreDataBenchmarkSuite.h"

@implementation EKBenchmark

+(void)startBenchmarking
{
    [self benchmarkNSObjects];
    [self benchmarkCoreData];
}

+ (void)benchmarkCoreData
{
    NSArray * suitNames = @[
                            @{ @"Car" : [ManagedMappingProvider carMapping] },
                            @{ @"CarWithRoot" : [ManagedMappingProvider carWithRootKeyMapping]},
                            @{ @"CarWithNestedAttributes" : [ManagedMappingProvider carNestedAttributesMapping]},
                            @{ @"CarWithDate" : [ManagedMappingProvider carWithDateMapping]},
                            @{ @"Person" : [ManagedMappingProvider personMapping]},
                            @{ @"PersonWithNullPhones" : [ManagedMappingProvider personWithCarMapping]},
                            @{ @"PersonWithNullCar" : [ManagedMappingProvider personWithPhonesMapping]},
                            @{ @"Male" : [ManagedMappingProvider personWithOnlyValueBlockMapping]},
                            ];
    NSMutableArray * suits = [NSMutableArray array];
    
    for (NSDictionary * nameInfo in suitNames)
    {
        NSString * key = [[nameInfo allKeys] lastObject];
        [suits addObject:[EKCoreDataBenchmarkSuite suiteWithMapping:nameInfo[key]
                                                fixtureName:key]];
    }
    NSLog(@"\n\nStarting CoreData benchmarking\n\n");
    NSTimeInterval benchTime = 0;
    for (EKBenchmarkSuite * suite in suits)
    {
        NSTimeInterval runTime = [suite runTimes:3000];
        NSLog(@"%@ : %f",suite.fixtureName,runTime);
        benchTime += runTime;
    }
    NSLog(@"\n\nTotal time: %f\n\n",benchTime);
}

+ (void)benchmarkNSObjects
{
    NSArray * suitNames = @[
                            @{ @"Car" : [MappingProvider carMapping] },
                            @{ @"CarWithRoot" : [MappingProvider carWithRootKeyMapping]},
                            @{ @"CarWithNestedAttributes" : [MappingProvider carNestedAttributesMapping]},
                            @{ @"CarWithDate" : [MappingProvider carWithDateMapping]},
                            @{ @"Person" : [MappingProvider personMapping]},
                            @{ @"PersonWithNullPhones" : [MappingProvider personWithCarMapping]},
                            @{ @"PersonWithNullCar" : [MappingProvider personWithPhonesMapping]},
                            @{ @"Male" : [MappingProvider personWithOnlyValueBlockMapping]},
                            @{ @"Address" : [MappingProvider addressMapping]},
                            @{ @"Native" : [MappingProvider nativeMapping]},
                            @{ @"Plane" : [MappingProvider planeMapping]},
                            @{ @"Alien" : [MappingProvider alienMapping]},
                            @{ @"NativeChild" : [MappingProvider nativeChildMapping]}
                            ];
    NSMutableArray * suits = [NSMutableArray array];
    
    for (NSDictionary * nameInfo in suitNames)
    {
        NSString * key = [[nameInfo allKeys] lastObject];
        [suits addObject:[EKBenchmarkSuite suiteWithMapping:nameInfo[key]
                                                 fixtureName:key]];
    }
    NSLog(@"\n\nStarting NSObject benchmarking\n\n");
    NSTimeInterval benchTime = 0;
    for (EKBenchmarkSuite * suite in suits)
    {
        NSTimeInterval runTime = [suite runTimes:20000];
        NSLog(@"%@ : %f",suite.fixtureName,runTime);
        benchTime += runTime;
    }
    NSLog(@"\n\nTotal time: %f\n\n",benchTime);
}

@end
