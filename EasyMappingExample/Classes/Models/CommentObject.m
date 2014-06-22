//
//  CommentObject.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 08.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "CommentObject.h"

@implementation CommentObject

static EKObjectMapping * mapping = nil;

+(void)registerMapping:(EKObjectMapping *)objectMapping
{
    mapping = objectMapping;
}

+(EKObjectMapping *)objectMapping
{
    return mapping;
}

@end
