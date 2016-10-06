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

@class EKPropertyMapping;
@class EKRelationshipMapping;
@protocol EKMappingProtocol;

NS_ASSUME_NONNULL_BEGIN

/**
 `EKObjectMapping` class is used to define mappings between JSON representation and objective-c object.
 */

@interface EKObjectMapping : NSObject

/**
 Defines if missing fields will be ignored, or as in case of relations set to nil
 */
@property (nonatomic, assign) BOOL ignoreMissingFields;

/**
 Defines if to-many relationship data is pushed or replaced.
 */
@property (nonatomic, assign) BOOL incrementalData;

/**
 If set to YES, mapper will introspect your class properties and try to create appropriate objects. Supported classes: NSMutableArray, NSMutableDictionary, NSSet, NSMutableSet, NSOrderedSet, NSMutableOrderedSet. 
 
 Due to perfomance reasons, this property defaults to NO.
 */
@property (nonatomic, assign) BOOL respectPropertyFoundationTypes;

/**
 Class, for which this mapping is meant to be used.
 */
@property (nonatomic, assign, readwrite) Class objectClass;

/**
 Root JSON path. This is helpful, when all object data is inside another JSON dictionary.
 */
@property (nonatomic, strong, readonly, nullable) NSString *rootPath;

/**
 Dictionary, containing property mappings for current object.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, EKPropertyMapping *> *propertyMappings;

/**
 Array, containing to-one relationships of current object.
 */
@property (nonatomic, strong, readonly) NSMutableArray<EKRelationshipMapping *> *hasOneMappings;

/**
 Array, containing to-many relationships of current object.
 */
@property (nonatomic, strong, readonly) NSMutableArray<EKRelationshipMapping *> *hasManyMappings;

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
 
 @param keyPath JSON keypath, that will be used by valueForKeyPath: method
 
 @param property Property name.
 */
- (void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property;

/**
 Map JSON keyPath to object property. This method assumes, that value contains NSString, that can be transformed into NSDate by NSDateFormatter.
 
 @param keyPath JSON keypath, that will be used by valueForKeyPath: method
 
 @param property Property name.
 
 @param formatter Date formatter to use when transforming string to dates and reverse.
 */
- (void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property withDateFormatter:(NSDateFormatter *)formatter;

/**
 Maps properties from array. We assume, that names of keypaths and properties are the same.
 
 @param propertyNamesArray Array of property names
 */
- (void)mapPropertiesFromArray:(NSArray<NSString *> *)propertyNamesArray;

/**
 Maps properties from array. We assume, that names of keypaths and properties are the same, except for the first letter, that is uppercased. For example, property @"name" will be filled, using "Name" value of JSON.
 
 @param propertyNamesArray Array of property names
 */
- (void)mapPropertiesFromArrayToPascalCase:(NSArray<NSString *> *)propertyNamesArray;

/**
 Maps properties from array, making all keypaths that contain underscores - camel cased. For example, @"created_at" field in JSON will be mapped to @"createdAt" property on your model.
 
 @param propertyNamesArray Array of property names.
 */
- (void)mapPropertiesFromUnderscoreToCamelCase:(NSArray<NSString *> *)propertyNamesArray;

/**
 Maps properties from dictionary. Keys are keypaths in JSON, values are names of properties.
 
 @param propertyDictionary Dictionary with keypaths and property names
 */
- (void)mapPropertiesFromDictionary:(NSDictionary<NSString *, NSString *> *)propertyDictionary;

/**
 Map mappings from another `EKObjectMapping` object. This can be useful with inheritance.
 */
- (void)mapPropertiesFromMappingObject:(EKObjectMapping *)mappingObj;

/**
 Map JSON keyPath to object property, using valueBlock.
 
 @param keyPath JSON keypath, that will be used by valueForKeyPath: method
 
 @param property Property name.
 
 @param valueBlock block to transform JSON value into property value.
 */
- (void)mapKeyPath:(NSString *)keyPath toProperty:(NSString *)property
    withValueBlock:(EKMappingValueBlock)valueBlock;

/**
 Map JSON keyPath to object property, using valueBlock. Include serialization block, that does reverse this operation.
 
 @param keyPath JSON keypath, that will be used by valueForKeyPath: method
 
 @param property Property name.
 
 @param valueBlock block to transform JSON value into property value.
 
 @param reverseBlock block to transform property value into JSON value
 */
- (void)mapKeyPath:(NSString *)keyPath
        toProperty:(NSString *)property
    withValueBlock:(EKMappingValueBlock)valueBlock
      reverseBlock:(EKMappingReverseBlock)reverseBlock;

/**
 Map to-one relationship for keyPath. Assuming keyPath and property name are equal. ObjectClass should conform to `EKMappingProtocol`.
 
 @param objectClass class for child object
 
 @param keyPath keyPath to child object representation in JSON
 
 @result The created relationship mapping
 */
- (EKRelationshipMapping *)hasOne:(Class)objectClass forKeyPath:(NSString *)keyPath;

/**
 Map to-one relationship for keyPath. ObjectClass should conform to `EKMappingProtocol`.
 
 @param objectClass class for child object
 
 @param keyPath keyPath to child object representation in JSON
 
 @param property Name of the property, that will receive mapped object.
 
 @result The created relationship mapping
 */
- (EKRelationshipMapping *)hasOne:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property;

/**
 Map to-one relationship, using keys that are on the same level as current object. They are collected into dictionary and passed along, as like they were in separate JSON dictionary.
 
 @param objectClass class, instance of which will be created as a result of mapping
 
 @param keyPaths Array of properties to collect from representation
 
 @param property name of the property, that will receive mapped object
 
 @param objectMapping optional mapping override for child object
 
 @result The created relationship mapping
 
 @warning If you have recursive mappings, do not use this method, cause it can cause infinite recursion to happen. Or you need to handle recursive mappings situation by yourself, subclassing EKObjectMapping and providing different mappings for different mapping levels.
 */
- (EKRelationshipMapping *)           hasOne:(Class)objectClass
                   forDictionaryFromKeyPaths:(NSArray *)keyPaths
                                 forProperty:(NSString *)property
                           withObjectMapping:(nullable EKObjectMapping *)objectMapping;

/**
 Map to-one relationship for keyPath.
 
 @param keyPath keyPath to child object representation in JSON
 
 @param property Name of the property, that will receive mapped object.

 @param objectMapping optional mapping override for child object
 
 @result The created relationship mapping
 
 @warning If you have recursive mappings, do not use this method, cause it can cause infinite recursion to happen. Or you need to handle recursive mappings situation by yourself, subclassing EKObjectMapping and providing different mappings for different mapping levels.
*/
- (EKRelationshipMapping *)hasOne:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property withObjectMapping:(nullable EKObjectMapping*)objectMapping;


/**
 Map to-many relationship for keyPath. Assuming keyPath and property name are equal. ObjectClass should conform to `EKMappingProtocol`.
 
 @param objectClass objectClass for child objects
 
 @param keyPath keyPath to child object representations in JSON
 */
- (EKRelationshipMapping *)hasMany:(Class)objectClass forKeyPath:(NSString *)keyPath;

/**
 Map to-many relationship for keyPath. ObjectClass should conform to `EKMappingProtocol`.
 
 @param objectClass objectClass for child objects
 
 @param keyPath keyPath to child objects representation in JSON
 
 @param property Name of the property, that will receive mapped objects.
 
 @result The created relationship mapping
 */
- (EKRelationshipMapping *)hasMany:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property;

/**
 Map to-many relationship for keyPath.
 
 @param keyPath keyPath to child objects representation in JSON
 
 @param property Name of the property, that will receive mapped objects.
 
 @param objectMapping optional mapping override for child objects
 
 @result The created relationship mapping
 
  @warning If you have recursive mappings, do not use this method, cause it can cause infinite recursion to happen. Or you need to handle recursive mappings situation by yourself, subclassing EKObjectMapping and providing different mappings for different mapping levels.
 */
- (EKRelationshipMapping *)hasMany:(Class)objectClass forKeyPath:(NSString *)keyPath forProperty:(NSString *)property withObjectMapping:(nullable EKObjectMapping*)objectMapping;

@end

NS_ASSUME_NONNULL_END
