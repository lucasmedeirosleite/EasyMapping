//
//  EKMapper.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 21/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EKManagedObjectMapping.h"
#import "EKObjectMapping.h"

@interface EKMapper : NSObject

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                           withMapping:(EKObjectMapping *)mapping;
+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                           withMapping:(EKManagedObjectMapping *)mapping
                inManagedObjectContext:(NSManagedObjectContext*)moc;

+ (id)            fillObject:(id)object
  fromExternalRepresentation:(NSDictionary *)externalRepresentation
                 withMapping:(EKObjectMapping *)mapping;
+ (id)            fillObject:(id)object
  fromExternalRepresentation:(NSDictionary *)externalRepresentation
                 withMapping:(EKManagedObjectMapping *)mapping
      inManagedObjectContext:(NSManagedObjectContext*)moc;


+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKObjectMapping *)mapping;

/** Get an array of managed objects from an external representation. If the mapping has
    a primary key existing objects will be updated. This method is slow and it doesn't
    delete obsolete objects, use
    syncArrayOfObjectsFromExternalRepresentation:withMapping:fetchRequest:inManagedObjectContext:
    instead.
 */
+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKManagedObjectMapping *)mapping
                               inManagedObjectContext:(NSManagedObjectContext*)moc;

/** Synchronize the objects in the managed obejct context with the objects from an external
    representation. Any new objects will be created, any existing objects will be updated
    and any object not present in the external representation will be deleted from the
    managed object context. The fetch request is used to pre-fetch all existing objects.
    This speeds up managed object lookup by a very significant amount.
 */
+ (NSArray *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                              withMapping:(EKManagedObjectMapping *)mapping
                                             fetchRequest:(NSFetchRequest*)fetchRequest
                                   inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
