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
                                      [mapping mapKeyPath:@"name" toProperty:@"name"];
                                      [mapping mapKeyPath:@"message" toProperty:@"message"];
                                      [mapping hasMany:self
                                            forKeyPath:@"sub_comments"
                                           forProperty:@"subComments"];
                                  }];
}

@end
