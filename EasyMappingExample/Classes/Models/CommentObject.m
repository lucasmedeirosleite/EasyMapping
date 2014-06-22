//
//  CommentObject.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 08.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "CommentObject.h"

@implementation CommentObject

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:[CommentObject class]
                                  withBlock:^(EKObjectMapping *mapping) {
                                      [mapping mapKey:@"name" toField:@"name"];
                                      [mapping mapKey:@"message" toField:@"message"];
                                      [mapping hasMany:self
                                            forKeyPath:@"sub_comments"
                                           forProperty:@"subComments"];
                                  }];
}

@end
