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

#import "EKMappingBlocks.h"

@protocol EKMappingProtocol;

/**
 `EKObjectMapping` class is used to define mappings between JSON representation and objective-c object.
 */

@interface EKObjectMapping : NSObject

/**
 Class, for which this mapping is meant to be used.
 */
@property (nonatomic, assign, readwrite) Class objectClass;

/**
 Root JSON path. This is helpful, when all object data is inside another JSON dictionary.
 */
@property (nonatomic, strong, readonly) NSString *rootPath;

/**
 Dictionary, containing field mappings for current object.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *fieldMappings;

/**
 Dictionary, containing to-one relationships of current object.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *hasOneMappings;

/**
 Dictionary, containing to-many relationships of current object.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *hasManyMappings;

/**
 Convenience initializer.
 
 @param objectClass Class of object, that will consume results of mapping
 
 @param mappingBlock Block, that contains created EKObjectMapping to be filled with mappings.
 
 @result object mapping
 */
+ (EKObjectMapping *)mappingForClass:(Class)objectClass
                           withBlock:(void(^)(EKObjectMapping *mapping))mappingBlock;

/**
 Convenience initializer.
 
 @param objectClass Class of object, that will consume results of mapping
 
 @param rootPath rootPath for mapping
 
 @param mappingBlock Block, that contains created EKObjectMapping to be filled with mappings.
 
 @result object mapping
 */
+ (EKObjectMapping *)mappingForClass:(Class)objectClass withRootPath:(NSString *)rootPath
                           withBlock:(void (^)(EKObjectMapping *mapping))mappingBlock;

/**
 Designated initializer
 
 @param objectClass Class of object, that will consume results of mapping
 
 @result object mapping
 */
- (instancetype)initWithObjectClass:(Class)objectClass;

/**
 Designated initializer
 
 @param objectClass Class of object, that will consume results of mapping
 
 @param rootPath rootPath for mapping
 
 @result object mapping
 */
- (instancetype)initWithObjectClass:(Class)objectClass withRootPath:(NSString *)rootPath;

/**
 Map JSON keyPath to object property.
 
 @param key JSON keypath, that will be used by valueForKeyPath: method
 
 @param field Property name.
 */
- (void)mapKey:(NSString *)key toField:(NSString *)field;

/**
 Map JSON keyPath to object property. This method assumes, that value contains NSString, that can be transformed into NSDate by NSDateFormatter. Default timezone is GMT. Transformation is done by `EKTransformer` class.
 
 @param key JSON keypath, that will be used by valueForKeyPath: method
 
 @param field Property name.
 
 @param dateFormat Date format
 */
- (void)mapKey:(NSString *)key toField:(NSString *)field withDateFormat:(NSString *)dateFormat;

/**
 Maps fields from array. We assume, that names of keypaths and properties are the same.
 
 @param fieldsArray Array of property names
 */
- (void)mapFieldsFromArray:(NSArray *)fieldsArray;

/**
 Maps fields from array. We assume, that names of keypaths and properties are the same, except for the first letter, that is uppercased. For example, property @"name" will be filled, using "Name" value of JSON.
 
 @param fieldsArray Array of property names
 */
- (void)mapFieldsFromArrayToPascalCase:(NSArray *)fieldsArray;

/**
 Maps fields from dictionary. Keys are keypaths in JSON, values are names of properties.
 
 @param fieldsDictionary Dictionary with keypaths and property names
 */
- (void)mapFieldsFromDictionary:(NSDictionary *)fieldsDictionary;

/**
 Map mappings from another `EKObjectMapping` object. This can be useful with inheritance.
 */
- (void)mapFieldsFromMappingObject:(EKObjectMapping *)mappingObj;

/**
 Map JSON keyPath to object property, using valueBlock.
 
 @param key JSON keypath, that will be used by valueForKeyPath: method
 
 @param field Property name.
 
 @param valueBlock block to transform JSON value into property value.
 */
- (void)mapKey:(NSString *)key toField:(NSString *)field
withValueBlock:(EKMappingValueBlock)valueBlock;

/**
 Map JSON keyPath to object property, using valueBlock. Include serialization block, that does reverse this operation.
 
 @param key JSON keypath, that will be used by valueForKeyPath: method
 
 @param field Property name.
 
 @param valueBlock block to transform JSON value into property value.
 
 @param reverseBlock block to transform property value into JSON value
 */
- (void)mapKey:(NSString *)key toField:(NSString *)field
withValueBlock:(EKMappingValueBlock)valueBlock withReverseBlock:(EKMappingReverseBlock)reverseBlock;

/**
 Map to-one relationship for keyPath. Assuming keyPath and property name are equal.
 
 @param mapping mapping for child object
 
 @param key keyPath to child object representation in JSON
 */

- (void)hasOne:(Class)objectClass forKeyPath:(NSString *)keyPath;

/**
 Map to-one relationship for keyPath.
 
 @param mapping mapping for child object
 
 @param key keyPath to child object representation in JSON
 
 @param field Name of the property, that will receive mapped object.
 */

- (void)hasOne:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property;

/**
 Map to-many relationship for keyPath. Assuming keyPath and property name are equal.
 
 @param mapping mapping for child objects
 
 @param key keyPath to child object representations in JSON
 */

- (void)hasMany:(Class)objectClass forKeyPath:(NSString *)keyPath;

/**
 Map to-many relationship for keyPath.
 
 @param mapping mapping for child objects
 
 @param key keyPath to child objects representation in JSON
 
 @param field Name of the property, that will receive mapped objects.
 */

- (void)hasMany:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property;

@end
