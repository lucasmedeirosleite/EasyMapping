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
#import "EKManagedObjectMapping.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `EKCoreDataImporter` is internal EasyMapping class and is used by `EKManagedObjectMapper` to manage CoreData imports and make them fast and efficient. It basically does 3 things:
 
 - Collect all entity names from mapping
 - Introspect passed JSON to collect all primary keys for collected entities
 - Prefetch all existing entities instead of fetching them one by one.
 
 The more high level JSON is passed to `EKCoreDataImporer`, the bigger perfomance win will be. If you can use methods like arrayOfObjectsFromExternalRepresentation: instead of objectFromExternalRepresentation, use them.
 */

@interface EKCoreDataImporter : NSObject

/**
 Context, on which import will be happening.
 */
@property (nonatomic, strong) NSManagedObjectContext * context;

/**
 Mapping for the JSON, that was passed to importer.
 */
@property (nonatomic, strong) EKManagedObjectMapping * mapping;

/**
 JSON representation of data to import.
 */
@property (nonatomic, strong) id externalRepresentation;

/**
 Create instance of `EKCoreDataImporter` and start collecting data from JSON and mapping. This is designated initializer.
 
 @param mapping object mapping
 
 @param externalRepresentation JSON, that will be mapped to objects
 
 @param context Context, on which all changes will happen
 
 @result CoreData importer
 */
+ (instancetype)importerWithMapping:(EKManagedObjectMapping *)mapping
            externalRepresentation:(id)externalRepresentation
                           context:(NSManagedObjectContext *)context;

/**
 Get's existing object by it's primary key value. Returns nil, if object does not exist in CoreData database.
 
 @param representation JSON representation of object
 
 @param mapping object mapping
 
 @result managed object
 */
- (nullable id)existingObjectForRepresentation:(id)representation mapping:(EKManagedObjectMapping *)mapping context:(NSManagedObjectContext *)context;

- (void)cacheObject:(NSManagedObject *)object withMapping:(EKManagedObjectMapping *)mapping;

@end

NS_ASSUME_NONNULL_END
