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

@import CoreData;
@import Foundation;
#import "EKPropertyMapping.h"
#import "EKObjectMapping.h"
#import "EKMappingProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `EKPropertyHelper` is internal EasyMapping class, that works with objective-c runtime to get and set values of properties.
 */
@interface EKPropertyHelper : NSObject

+ (BOOL)propertyNameIsScalar:(NSString *)propertyName fromObject:(id)object;

+ (nullable id)propertyRepresentation:(NSArray *)array forObject:(id)object withPropertyName:(NSString *)propertyName;

+ (void)  setProperty:(EKPropertyMapping *)propertyMapping
             onObject:(id<EKMappingProtocol>)object
   fromRepresentation:(NSDictionary *)representation
  respectPropertyType:(BOOL)respectPropertyType
 ignoreMissingFields:(BOOL)ignoreMissingFields;

+ (void) setProperty:(EKPropertyMapping *)propertyMapping
            onObject:(id<EKManagedMappingProtocol>)object
  fromRepresentation:(NSDictionary *)representation
           inContext:(NSManagedObjectContext *)context
 respectPropertyType:(BOOL)respectPropertyType
 ignoreMissingFields:(BOOL)ignoreMissingFields;

+ (nullable id)getValueOfProperty:(EKPropertyMapping *)propertyMapping
               fromRepresentation:(NSDictionary *)representation
              ignoreMissingFields:(BOOL)ignoreMissingFields;

+ (nullable id)getValueOfManagedProperty:(EKPropertyMapping *)mapping
                      fromRepresentation:(NSDictionary *)representation
                               inContext:(NSManagedObjectContext *)context;

+ (void)setValue:(nullable id)value onObject:(id)object forKeyPath:(NSString *)keyPath;

+ (void)addValue:(id)value onObject:(id)object forKeyPath:(NSString *)keyPath;

+ (nullable NSDictionary *)extractRootPathFromExternalRepresentation:(NSDictionary *)externalRepresentation
                                                         withMapping:(EKObjectMapping *)mapping;

+ (NSString *)convertStringFromUnderScoreToCamelCase:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
