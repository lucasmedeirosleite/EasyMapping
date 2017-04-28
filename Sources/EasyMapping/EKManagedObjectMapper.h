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

#import <CoreData/CoreData.h>
#import "EKManagedObjectMapping.h"
#import "EKMappingProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `EKManagedObjectMapper` is used to create and fill CoreData objects. Internally, it uses `EKCoreDataImporter` class to speed up data imports. You can find more info on this in project's readme.
 */
@interface EKManagedObjectMapper : NSObject

/**
 Creates object from JSON representation, using `mapping` in `context`.
 
 @param externalRepresentation JSON representation of object data
 
 @param mapping object mapping
 
 @param context managed object context to perform object creation
 
 @result mapped managed object
 */
+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                           withMapping:(EKManagedObjectMapping *)mapping
                inManagedObjectContext:(NSManagedObjectContext*)context;

/**
 Fills previously existed object with values, provided in JSON representation. All values, that are included in mapping and were filled prior to calling this method, will be overwritten.
 
 @param object Object to fill
 
 @param externalRepresentation JSON representation of object data
 
 @param mapping object mapping
 
 @param context managed object context to perform object creation
 
 @result filled managed object
 */
+ (id<EKManagedMappingProtocol>)fillObject:(id<EKManagedMappingProtocol>)object
                fromExternalRepresentation:(NSDictionary *)externalRepresentation
                               withMapping:(EKManagedObjectMapping *)mapping
                    inManagedObjectContext:(NSManagedObjectContext*)context;

/**
 Create array of CoreData objects. If passed JSON contains primary keys, previously existing object with these keys will be updated. Simply put, this method uses Find-Or-Create pattern.
 
 @param externalRepresentation JSON array with objects
 
 @param mapping object mapping
 
 @param context managed object context to perform objects creation
 
 @result array of managed objects
 */
+ (NSArray<EKManagedMappingProtocol> *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                                                    withMapping:(EKManagedObjectMapping *)mapping
                                                         inManagedObjectContext:(NSManagedObjectContext*)context;

/** 
 Synchronize the objects in the managed object context with the objects from an external
 representation. Any new objects will be created, any existing objects will be updated
 and any object not present in the external representation will be deleted from the
 managed object context. The fetch request is used to pre-fetch all existing objects.
 
 @param externalRepresentation JSON array with objects
 
 @param mapping object mapping
 
 @param fetchRequest Fetch request to get existing objects
 
 @param context managed object context to perform objects creation
 
 @result array of managed objects
 */
+ (NSArray<EKManagedMappingProtocol> *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                                                        withMapping:(EKManagedObjectMapping *)mapping
                                                                       fetchRequest:(NSFetchRequest*)fetchRequest
                                                             inManagedObjectContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END
