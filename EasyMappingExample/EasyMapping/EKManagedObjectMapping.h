//
//  EKManagedObjectMapping.h
//  EasyMappingExample
//
//  Created by Alejandro Isaza on 2013-03-13.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKMappingBlocks.h"

@interface EKManagedObjectMapping : NSObject

@property (nonatomic, assign, readonly) NSString* entityName;
@property (nonatomic, strong, readonly) NSString *rootPath;
@property (nonatomic, strong, readonly) NSMutableDictionary *fieldMappings;
@property (nonatomic, strong, readonly) NSMutableDictionary *hasOneMappings;
@property (nonatomic, strong, readonly) NSMutableDictionary *hasManyMappings;

+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                       withBlock:(void(^)(EKManagedObjectMapping *mapping))mappingBlock;
+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName
                                    withRootPath:(NSString *)rootPath
                                       withBlock:(void (^)(EKManagedObjectMapping *mapping))mappingBlock;

- (id)initWithEntityName:(NSString *)entityName;
- (id)initWithEntityName:(NSString *)entityName withRootPath:(NSString *)rootPath;

- (void)mapKey:(NSString *)key toField:(NSString *)field;
- (void)mapKey:(NSString *)key toField:(NSString *)field withDateFormat:(NSString *)dateFormat;
- (void)mapFieldsFromArray:(NSArray *)fieldsArray;
- (void)mapFieldsFromDictionary:(NSDictionary *)fieldsDictionary;
- (void)mapKey:(NSString *)key toField:(NSString *)field
withValueBlock:(EKMappingValueBlock)valueBlock;
- (void)mapKey:(NSString *)key toField:(NSString *)field
withValueBlock:(EKMappingValueBlock)valueBlock withReverseBlock:(EKMappingReverseBlock)reverseBlock;
- (void)hasOneMapping:(EKManagedObjectMapping *)mapping forKey:(NSString *)key;
- (void)hasManyMapping:(EKManagedObjectMapping *)mapping forKey:(NSString *)key;

@end
