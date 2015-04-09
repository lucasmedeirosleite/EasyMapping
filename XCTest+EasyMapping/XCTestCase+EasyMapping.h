//
//  XCTestCase+EasyMapping.h
//  EasyMappingExample
//
//  Created by Ilya Puchka on 14.01.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import <XCTest/XCTest.h>

@class EKObjectMapping;

#pragma clang assume_nonnull begin

@interface XCTestCase (EasyMapping)

- (nullable id)testObjectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                                        withMapping:(EKObjectMapping *)mapping
                                     expectedObject:(id)expectedObject;

- (nullable id)testObjectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                                        withMapping:(EKObjectMapping *)mapping
                                     expectedObject:(id)expectedObject
                                   skippingKeyPaths:(nullable NSArray *)keyPathsToSkip;

- (NSDictionary *)testSerializeObject:(id)object
                          withMapping:(EKObjectMapping *)mapping
               expectedRepresentation:(NSDictionary *)expectedRepresentation;

- (NSDictionary *)testSerializeObject:(id)object
                          withMapping:(EKObjectMapping *)mapping
               expectedRepresentation:(NSDictionary *)expectedRepresentation
                     skippingKeyPaths:(nullable NSArray *)keyPathsToSkip;


@end

#pragma clang assume_nonnull end
