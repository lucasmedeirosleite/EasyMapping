//
//  XCTestCase+EasyMapping.h
//  EasyMappingExample
//
//  Created by Ilya Puchka on 14.01.15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import <XCTest/XCTest.h>

@class EKObjectMapping;

#if __has_feature(nullability) // Xcode 6.3+
#pragma clang assume_nonnull begin
#else
#define nullable
#define __nullable
#endif

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

#if __has_feature(nullability)
#pragma clang assume_nonnull end
#endif

