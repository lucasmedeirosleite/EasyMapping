//
//  Playlist.h
//  EasyMappingExample
//
//  Created by Anton Pomozov on 07.11.13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Playlist : NSObject

@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *etag;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, strong) NSDate *publishedAt;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *itemDescription;
@property (nonatomic, copy) NSString *defaultUrl;
@property (nonatomic, copy) NSString *mediumUrl;
@property (nonatomic, copy) NSString *highUrl;
@property (nonatomic, copy) NSString *channelTitle;

@end
