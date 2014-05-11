//
//  EKPropertyHelper.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 26/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKFieldMapping.h"
#import "EKObjectMapping.h"
#import "EKManagedObjectMapping.h"

@interface EKPropertyHelper : NSObject

+ (BOOL)propertyNameIsScalar:(NSString *)propertyName fromObject:(id)object;

+ (id)propertyRepresentation:(NSArray *)array forObject:(id)object withPropertyName:(NSString *)propertyName;

+ (void)  setField:(EKFieldMapping *)fieldMapping
          onObject:(id)object
fromRepresentation:(NSDictionary *)representation;

+ (id)getValueOfField:(EKFieldMapping *)fieldMapping
   fromRepresentation:(NSDictionary *)representation;

+ (NSDictionary *)extractRootPathFromExternalRepresentation:(NSDictionary *)externalRepresentation
                                                withMapping:(EKObjectMapping *)mapping;

@end
