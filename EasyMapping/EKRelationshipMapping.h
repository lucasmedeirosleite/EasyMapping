//
//  EKRelationshipMapping.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 14.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKObjectMapping.h"
#import "EKMappingProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface EKRelationshipMapping : NSObject

@property (nonatomic, strong) Class <EKMappingProtocol> objectClass;

@property (nonatomic, strong) NSString * keyPath;

@property (nonatomic, strong) NSString * property;

@property (nonatomic, strong) EKObjectMapping *objectMapping;

@property (nonatomic, strong, nullable) NSArray<NSString *> * nonNestedKeyPaths;

- (nullable NSDictionary *)extractObjectFromRepresentation:(NSDictionary *)representation;

@end

NS_ASSUME_NONNULL_END
