//
//  EKAppDelegate.m
//  iOS Benchmark
//
//  Created by Denys Telezhkin on 04.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKAppDelegate.h"
#import "EKCoreDataManager.h"
#import "EKBenchmark.h"

@implementation EKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [EKCoreDataManager cleanupDatabase];
    [EKBenchmark startBenchmarking];
    exit(0);
    return YES;
}

@end
