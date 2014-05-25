![Build Status](https://travis-ci.org/EasyMapping/EasyMapping.png?branch=master) &nbsp;
![CocoaPod platform](https://cocoapod-badges.herokuapp.com/p/EasyMapping/badge.png) &nbsp; ![CocoaPod version](https://cocoapod-badges.herokuapp.com/v/EasyMapping/badge.png) &nbsp; ![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)

# EasyMapping

An easy way to unmarshall a Dictionary of attributes (which came from JSON, XML or just a NSDictionary) into a Class and vice versa.

##Contact:

Developed by [Lucas Medeiros](https://www.twitter.com/aspmedeiros)
E-mail: lucastoc@gmail.com

## Usage

* Suppose you have these classes:

```objective-c

typedef enum {
    GenderMale,
    GenderFemale
} Gender;

@interface Person : NSObject

@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *email;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, strong) Car *car;
@property (nonatomic, strong) NSArray *phones;

@end

@interface Car : NSObject

@property (nonatomic, copy)   NSString *model;
@property (nonatomic, copy)   NSString *year;
@property (nonatomic, strong) NSDate *createdAt;

@end

@interface Phone : NSObject

@property (nonatomic, copy) NSString *DDI;
@property (nonatomic, copy) NSString *DDD;
@property (nonatomic, copy) NSString *number;

@end

@interface Native : NSObject

@property (nonatomic, readwrite) NSInteger integerProperty;
@property (nonatomic, readwrite) NSUInteger unsignedIntegerProperty;
@property (nonatomic, readwrite) CGFloat cgFloatProperty;
@property (nonatomic, readwrite) double doubleProperty;
@property (nonatomic, readwrite) BOOL boolProperty;

@end

```

* Map your classes in any place you want. An example:

```objective-c

#import "MappingProvider.h"
#import "Car.h"
#import "Phone.h"
#import "Person.h"
#import "Address.h"

@implementation MappingProvider

+ (EKObjectMapping *)carMapping
{
    return [EKObjectMapping mappingForClass:[Car class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"model", @"year"]];
        [mapping mapKey:@"created_at" toField:@"createdAt" withDateFormat:@"yyyy-MM-dd"];
    }];
}

+ (EKObjectMapping *)phoneMapping
{
    return [EKObjectMapping mappingForClass:[Phone class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[@"number"]];
        [mapping mapFieldsFromDictionary:@{
            @"ddi" : @"DDI",
            @"ddd" : @"DDD"
         }];
    }];
}

+ (EKObjectMapping *)personMapping
{
    return [EKObjectMapping mappingForClass:[Person class] withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping mapFieldsFromArray:@[@"name", @"email"]];
        [mapping mapKey:@"gender" toField:@"gender" withValueBlock:^(NSString *key, id value) {
            return genders[value];
        } withReverseBlock:^id(id value) {
           return [genders allKeysForObject:value].lastObject;
        }];
        [mapping hasOneMapping:[self carMapping] forKey:@"car"];
        [mapping hasManyMapping:[self phoneMapping] forKey:@"phones"];
    }];
}

+ (EKObjectMapping *)nativeMapping
{
    return [EKObjectMapping mappingForClass:[Native class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapFieldsFromArray:@[
         @"integerProperty", @"unsignedIntegerProperty", 
         @"cgFloatProperty", @"doubleProperty", 
         @"boolProperty"
        ]];
    }];
}

```

* Converting a NSDictionary or NSArray to a object class or collection now becomes easy:

```objective-c

Person *person = [EKMapper objectFromExternalRepresentation:personRepresentation 
                                                withMapping:[MappingProvider personMapping]];

NSArray *carsArray = [EKMapper arrayOfObjectsFromExternalRepresentation:carsRepresentation 
                                                            withMapping:[MappingProvider carMapping]];

```

* Converting an object/collection to NSDictionary/NSArray:

```objective-c
NSDictionary *representation = [EKSerializer serializeObject:car withMapping:[MappingProvider carMapping]];
NSArray *collectionRepresentation = [EKSerializer serializeCollection:cars withMapping:[MappingProvider carMapping]];
```

* Filling an existent object:

Suppose you have something like this:

```objective-c
Person *person = [Person alloc] init];	
```

To fill an already instantiated object you can do this:

```objective-c

[EKMapper fillObject:person fromExternalRepresentation:personRepresentation withMapping:[Mappings personMapping]];

```

* See the specs code

### CoreData

If you are using CoreData objects use `EKManagedObjectMapping` instead of `EKObjectMapping`.

## Thanks

Thanks to: 

* [basitali](https://github.com/basitali) who added the fillObject functionality on EKMapper!
* [Alejandro](https://github.com/aleph7) who added CoreData support!
* [DenHeadless](https://github.com/DenHeadless) who added the ability to use different naming in hasOne and hasMany mappings!
* [ArtFeel](https://github.com/ArtFeel) who added the ability to serialization/deserialization of primitive types!
* [Dany L'Hébreux](https://github.com/danylhebreux) who added the NSSet support!
* [Jack](https://github.com/Jack-s) who added mapFieldsFromMappingObject and mapFieldsFromArrayToPascalCase functionality

## Requirements

* iOS 5 and higher
* Mac OS X 10.7 and higher
* ARC

## Installation

Using CocoaPods:

	pod 'EasyMapping','~>0.6.0'
	
## The idea

The idea came from:
* [RestKit's](https://github.com/RestKit/Restkit) mapping, its problem is that it doesn't transform
custom values (such as a string value to an enum)
* [Mantle's](https://github.com/github/Mantle) mapping, but you don't need to inherit from any class

