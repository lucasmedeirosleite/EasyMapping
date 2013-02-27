//
//  EKPropertyHelper.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 26/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKPropertyHelper : NSObject

+ (id)perfomSelector:(SEL)selector onObject:(id)object;
+ (void *)performSelector:(SEL)selector onObject:(id)object;
+ (BOOL)propertyNameIsNative:(NSString *)propertyName fromObject:(id)object;

@end
