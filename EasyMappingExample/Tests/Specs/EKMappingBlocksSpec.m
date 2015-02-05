//
//  EKMappingBlocksTestCase.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 01.02.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EKMappingBlocks.h"

SPEC_BEGIN(EKMappingBlocksTestCase)


describe(@"Mapping blocks tests", ^{
    
    it(@"should convert from string to URL", ^{
        NSString * string = @"http://www.google.com";
        
        NSURL * url = [EKMappingBlocks urlMappingBlock](@"foo",string);
        
        [[url should] beKindOfClass:[NSURL class]];
        [[[url absoluteString] should] equal:string];
    });
    
    it(@"should return nil on non-string value", ^{
        NSNumber * foo = @6;
        
        NSURL * nilURL = [EKMappingBlocks urlMappingBlock](@"foo",foo);
        
        [[nilURL should] beNil];
    });
    
    it(@"should reverse convert NSURL to string", ^{
        NSURL * url = [NSURL URLWithString:@"http://www.google.com"];
        
        NSString * string = [EKMappingBlocks urlReverseMappingBlock](url);
        
        [[string should]equal:[url absoluteString]];
    });
    
    it(@"should be null, if url is nil", ^{
        NSURL * nilURL = nil;
        NSString * string = [EKMappingBlocks urlReverseMappingBlock](nilURL);
        
        [[string should] beNil];
    });
});

SPEC_END

