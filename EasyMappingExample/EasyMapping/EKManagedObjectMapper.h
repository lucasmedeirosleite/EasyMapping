//
//  EKManagedObjectMapper.h
//  EasyMappingExample
//
//  Created by Alejandro Isaza on 2013-03-13.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EKManagedObjectMapping.h"

@interface EKManagedObjectMapper : NSObject

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext*)moc;
+ (id)fillObject:(id)object fromExternalRepresentation:(NSDictionary *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext*)moc;
+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation withMapping:(EKManagedObjectMapping *)mapping inManagedObjectContext:(NSManagedObjectContext*)moc;

@end
