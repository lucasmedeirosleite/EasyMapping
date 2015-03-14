//
//  EKRelationshipMapping.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 14.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKObjectMapping.h"
#import "EKMappingProtocol.h"

#if __has_feature(nullability) // Xcode 6.3+
#pragma clang assume_nonnull begin
#else
#define nullable
#define __nullable
#endif

@interface EKRelationshipMapping : NSObject

@property (nonatomic, strong) Class <EKMappingProtocol> objectClass;

@property (nonatomic, strong) NSString * keyPath;

@property (nonatomic, strong) NSString * property;

@property (nonatomic, strong) EKObjectMapping *objectMapping;

@property (nonatomic, strong, nullable) NSArray * nonNestedKeyPaths;

- (NSDictionary *)extractObjectFromRepresentation:(NSDictionary *)representation;

@end

#if __has_feature(nullability)
#pragma clang assume_nonnull end
#endif

