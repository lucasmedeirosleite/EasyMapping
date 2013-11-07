//
//  Response.h
//  EasyMappingExample
//
//  Created by Anton Pomozov on 07.11.13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *etag;
@property (nonatomic, assign) NSUInteger totalResults;
@property (nonatomic, assign) NSUInteger resultsPerPage;
@property (nonatomic, strong) NSArray *items;

@end
