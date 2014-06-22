//
//  CommentObject.h
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 08.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTestModel.h"

@interface CommentObject : BaseTestModel

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSArray * subComments;

@end
