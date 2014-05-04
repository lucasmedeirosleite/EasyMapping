//
//  EKBenchmarkSuite.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 04.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKBenchmarkSuite.h"
#import "CMFixture.h"
#import "EKMapper.h"

@implementation EKBenchmarkSuite

+(instancetype)suiteWithMapping:(EKObjectMapping *)mapping fixtureName:(NSString *)fixtureName
{
    EKBenchmarkSuite * suite = [self new];
    suite.mapping = mapping;
    suite.fixtureName = fixtureName;
    return suite;
}

-(id)externalRepresentation
{
    return [CMFixture buildUsingFixture:self.fixtureName];
}

-(void)runSingleSuite
{
    [EKMapper objectFromExternalRepresentation:[self externalRepresentation]
                                   withMapping:self.mapping];
}

-(NSTimeInterval)runTimes:(NSInteger)howManyTimes
{
    NSTimeInterval interval = 0;
    
    for (int i = 0;i<howManyTimes;i++)
    {
        @autoreleasepool {
            NSDate * start = [NSDate date];
            [self runSingleSuite];
            interval += [[NSDate date] timeIntervalSinceDate:start];
        }
    }
    
    return interval;
}

@end
