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

#import "EKObjectMapping.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `EKMapper` provides an interface to create objective-c object from JSON representation, using `EKObjectMapping` class. For creating CoreData objects, use `EKManagedObjectMapper` class.
 */

@interface EKMapper : NSObject

/**
 Creates object from JSON representation, using mapping.
 
 @param externalRepresentation JSON representation of object data
 
 @param mapping object mapping
 
 @result mapped object
 */
+ (nullable id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                                    withMapping:(EKObjectMapping *)mapping;

/**
 Fills previously existed object with values, provided in JSON representation. All values, that are included in mapping and were filled prior to calling this method, will be overwritten.
 
 @param object Object to fill 
 
 @param externalRepresentation JSON representation of object data
 
 @param mapping object mapping
 
 @result filled object
 */
+ (id)            fillObject:(id<EKMappingProtocol>)object
  fromExternalRepresentation:(NSDictionary *)externalRepresentation
                 withMapping:(EKObjectMapping *)mapping;

/**
 Convenience method to create array of objects from JSON.
 
 @param externalRepresentation JSON array with objects
 
 @param mapping object mapping
 
 @result array of mapped objects
 */
+ (nullable NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                                   withMapping:(EKObjectMapping *)mapping;

@end

NS_ASSUME_NONNULL_END
