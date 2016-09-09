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
#import "EKManagedObjectMapping.h"
#import "EKMappingProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `EKSerializer` is a class, that allows converting objects to their JSON representation, using `EKObjectMapping`. CoreData objects are supported too.
 */
@interface EKSerializer : NSObject

/**
 Convert object to JSON representation.
 
 @param object object to convert.
 
 @param mapping object mapping.
 
 @result parsed JSON in a form of NSDictionary.
 */
+ (NSDictionary *)serializeObject:(id<EKMappingProtocol>)object withMapping:(EKObjectMapping *)mapping;

/**
 Convert objects to JSON representation.
 
 @param collection objects to convert.
 
 @param mapping object mapping.
 
 @result parsed JSON in a form of NSArray.
 */
+ (NSArray *)serializeCollection:(NSArray<EKMappingProtocol> *)collection withMapping:(EKObjectMapping *)mapping;

/**
 Convert CoreData managed object to JSON representation.
 
 @param object object to convert.
 
 @param mapping object mapping.
 
 @param context NSManagedObjectContext objects are in. If you don't use context lookups in reverse blocks, you can simply pass nil.
 
 @result parsed JSON in a form of NSDictionary.
 */
+ (NSDictionary *)serializeObject:(id<EKManagedMappingProtocol>)object
                      withMapping:(EKManagedObjectMapping *)mapping
                      fromContext:(NSManagedObjectContext *)context;

/**
 Convert CoreData managed objects to JSON representation.
 
 @param collection objects to convert.
 
 @param mapping object mapping.
 
 @param context NSManagedObjectContext objects are in. If you don't use context lookups in reverse blocks, you can simply pass nil.
 
 @result parsed JSON in a form of NSArray.
 */
+ (NSArray *)serializeCollection:(NSArray<EKManagedMappingProtocol> *)collection
                     withMapping:(EKManagedObjectMapping*)mapping
                     fromContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END
