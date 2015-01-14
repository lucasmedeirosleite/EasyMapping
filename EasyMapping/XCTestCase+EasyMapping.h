//
//  XCTestCase+EasyMapping.h
//  EasyMappingExample
//
//  Created by Ilya Puchka on 14.01.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import <XCTest/XCTest.h>

@class EKObjectMapping;

@interface XCTestCase (EasyMapping)

- (id)    testMapping:(EKObjectMapping *)mapping
   withRepresentation:(NSDictionary *)representation
       expectedObject:(id)expectedObject;

- (id)    testMapping:(EKObjectMapping *)mapping
   withRepresentation:(NSDictionary *)representation
       expectedObject:(id)expectedObject
     skippingKeyPaths:(NSArray *)keyPathsToSkip;

- (NSDictionary *)testSerializationUsingMapping:(EKObjectMapping *)mapping
                                     withObject:(id)object
                         expectedRepresentation:(NSDictionary *)expectedRepresentation;

- (NSDictionary *)testSerializationUsingMapping:(EKObjectMapping *)mapping
                                     withObject:(id)object
                         expectedRepresentation:(NSDictionary *)expectedRepresentation
                               skippingKeyPaths:(NSArray *)keyPathsToSkip;

@end
