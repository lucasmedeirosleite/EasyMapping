//
//  Phone.h
//  EasyMappingCoreDataExample
//
//  Created by Alejandro Isaza on 2013-03-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManagedTestModel.h"

@class ManagedPerson;

@interface ManagedPhone : BaseManagedTestModel

@property (nonatomic, retain) NSNumber * phoneID;
@property (nonatomic, retain) NSString * ddi;
@property (nonatomic, retain) NSString * ddd;
@property (nonatomic, retain) NSString * number;

@end
