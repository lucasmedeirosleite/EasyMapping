//
//  EKFieldMapping.h
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 22/02/13.
//  Copyright (c) 2013 EasyKit. All rights reserved.
//

#import "EKMappingBlocks.h"

@interface EKFieldMapping : NSObject

@property (nonatomic, strong) NSString *keyPath;
@property (nonatomic, strong) NSString *field;
@property (nonatomic, strong) NSString *dateFormat;
@property (nonatomic, strong) EKMappingValueBlock valueBlock;
@property (nonatomic, strong) EKMappingReverseBlock reverseBlock;

@end
