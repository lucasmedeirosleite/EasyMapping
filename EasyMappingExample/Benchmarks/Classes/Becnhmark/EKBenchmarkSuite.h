//
//  EKBenchmarkSuite.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 04.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKObjectMapping.h"

@interface EKBenchmarkSuite : NSObject

// Public

@property (nonatomic, strong) NSString * fixtureName;
@property (nonatomic, strong) EKObjectMapping * mapping;

+(instancetype)suiteWithMapping:(EKObjectMapping *)mapping
                    fixtureName:(NSString *)fixtureName;

-(NSTimeInterval)runTimes:(NSInteger)howManyTimes;

// Private

-(id)externalRepresentation;
-(void)runSingleSuite;
@end
