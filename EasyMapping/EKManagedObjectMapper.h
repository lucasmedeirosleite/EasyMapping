//
//  EKManagedObjectMapper.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 10.05.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKMapper.h"

@interface EKManagedObjectMapper : NSObject

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation
                           withMapping:(EKManagedObjectMapping *)mapping
                inManagedObjectContext:(NSManagedObjectContext*)moc;

+ (id)            fillObject:(id)object
  fromExternalRepresentation:(NSDictionary *)externalRepresentation
                 withMapping:(EKManagedObjectMapping *)mapping
      inManagedObjectContext:(NSManagedObjectContext*)moc;


/** Get an array of managed objects from an external representation. If the mapping has
 a primary key existing objects will be updated.
 */
+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                          withMapping:(EKManagedObjectMapping *)mapping
                               inManagedObjectContext:(NSManagedObjectContext*)moc;

/** Synchronize the objects in the managed object context with the objects from an external
 representation. Any new objects will be created, any existing objects will be updated
 and any object not present in the external representation will be deleted from the
 managed object context. The fetch request is used to pre-fetch all existing objects.
 */
+ (NSArray *)syncArrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                              withMapping:(EKManagedObjectMapping *)mapping
                                             fetchRequest:(NSFetchRequest*)fetchRequest
                                   inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
