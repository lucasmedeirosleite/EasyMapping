//
//  EKRelationshipMapping.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 14.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKObjectMapping.h"
#import "EKMappingProtocol.h"
#import "EKMappingBlocks.h"

NS_ASSUME_NONNULL_BEGIN

typedef EKObjectMapping * _Nonnull (^EKMappingResolvingBlock)(id representation);
typedef EKObjectMapping * _Nonnull (^EKSerializationResolvingBlock)(id object);

@interface EKRelationshipMapping : NSObject

@property (nonatomic, strong) EKMappingResolvingBlock mappingResolver;

@property (nonatomic, strong) EKSerializationResolvingBlock serializationResolver;

@property (nonatomic, strong) NSString * keyPath;

@property (nonatomic, strong) NSString * property;

@property (nonatomic, strong) Class <EKMappingProtocol> objectClass;

@property (nonatomic, strong, nullable) NSArray<NSString *> * nonNestedKeyPaths;

@property (nonatomic, strong, nullable) EKMappingConditionBlock condition;

- (nullable NSDictionary *)extractObjectFromRepresentation:(NSDictionary *)representation;

- (EKObjectMapping *)mappingForRepresentation:(id)representation;

- (EKObjectMapping *)mappingForObject:(id)object;

@end

NS_ASSUME_NONNULL_END
