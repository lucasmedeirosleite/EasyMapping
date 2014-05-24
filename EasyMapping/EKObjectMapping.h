//
//  EasyMapping
//
//  Copyright (c) 2012-2014 Lucas Medeiros.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
