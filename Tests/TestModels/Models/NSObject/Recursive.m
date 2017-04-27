//
//  Recursive.m
//  EasyMappingExample
//
//  Created by Денис Тележкин on 03.04.17.
//  Copyright © 2017 EasyKit. All rights reserved.
//

#import "Recursive.h"

@implementation Recursive
    
@dynamic id;
@dynamic link;
    
+(EKManagedObjectMapping *)objectMapping
{
    EKManagedObjectMapping * mapping = [super objectMapping];
    
    [mapping mapKeyPath:@"id" toProperty:@"id"];
    [mapping hasOne:[Recursive class] forKeyPath:@"link"];
    
    return mapping;
}

@end
