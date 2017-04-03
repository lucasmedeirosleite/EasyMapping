//
//  Recursive.h
//  EasyMappingExample
//
//  Created by Денис Тележкин on 03.04.17.
//  Copyright © 2017 EasyKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKManagedObjectModel.h"

@interface Recursive : EKManagedObjectModel
    
@property (nonatomic,strong, nonnull) NSString * id;
@property (nonatomic, strong, nullable) Recursive * link;

@end
