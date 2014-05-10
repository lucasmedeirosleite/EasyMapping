//
//  EKObjectMapping.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKMappingBlocks.h"

@interface EKObjectMapping : NSObject

@property (nonatomic, assign, readwrite) Class objectClass;
@property (nonatomic, strong, readonly) NSString *rootPath;
@property (nonatomic, strong, readwrite) NSString * field;
@property (nonatomic, strong, readwrite) NSString * keyPath;

@property (nonatomic, strong, readonly) NSMutableDictionary *fieldMappings;
@property (nonatomic, strong, readonly) NSMutableDictionary *hasOneMappings;
@property (nonatomic, strong, readonly) NSMutableDictionary *hasManyMappings;

+ (EKObjectMapping *)mappingForClass:(Class)objectClass withBlock:(void(^)(EKObjectMapping *mapping))mappingBlock;
+ (EKObjectMapping *)mappingForClass:(Class)objectClass withRootPath:(NSString *)rootPath
                           withBlock:(void (^)(EKObjectMapping *mapping))mappingBlock;

- (instancetype)initWithObjectClass:(Class)objectClass;
- (instancetype)initWithObjectClass:(Class)objectClass withRootPath:(NSString *)rootPath;

- (void)mapKey:(NSString *)key toField:(NSString *)field;
- (void)mapKey:(NSString *)key toField:(NSString *)field withDateFormat:(NSString *)dateFormat;

- (void)mapFieldsFromArray:(NSArray *)fieldsArray;
- (void)mapFieldsFromArrayToPascalCase:(NSArray *)fieldsArray;
- (void)mapFieldsFromDictionary:(NSDictionary *)fieldsDictionary;
- (void)mapFieldsFromMappingObject:(EKObjectMapping *)mappingObj;

- (void)mapKey:(NSString *)key toField:(NSString *)field
withValueBlock:(EKMappingValueBlock)valueBlock;
- (void)mapKey:(NSString *)key toField:(NSString *)field
withValueBlock:(EKMappingValueBlock)valueBlock withReverseBlock:(EKMappingReverseBlock)reverseBlock;

- (void)hasOneMapping:(EKObjectMapping *)mapping forKey:(NSString *)key;
- (void)hasOneMapping:(EKObjectMapping *)mapping forKey:(NSString *)key forField:(NSString *)field;

- (void)hasManyMapping:(EKObjectMapping *)mapping forKey:(NSString *)key;
- (void)hasManyMapping:(EKObjectMapping *)mapping forKey:(NSString *)key forField:(NSString *)field;

@end
