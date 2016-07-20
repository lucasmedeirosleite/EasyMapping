[![Build Status](https://travis-ci.org/lucasmedeirosleite/EasyMapping.svg?branch=master)](https://travis-ci.org/lucasmedeirosleite/EasyMapping) &nbsp;
![CocoaPod platform](https://cocoapod-badges.herokuapp.com/p/EasyMapping/badge.png) &nbsp; 
![CocoaPod version](https://cocoapod-badges.herokuapp.com/v/EasyMapping/badge.png) &nbsp; 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)

# EasyMapping

An easy way to unmarshall a Dictionary of attributes (which came from JSON, XML or just a NSDictionary) into a Class and vice versa.

##Contact:

Developed by [Lucas Medeiros](https://www.twitter.com/aspmedeiros) and [Denys Telezhkin](https://www.twitter.com/DTCoder)

E-mail: lucastoc@gmail.com

## Usage

* Suppose you have these classes:

```objective-c

typedef enum {
    GenderMale,
    GenderFemale
} Gender;

@interface Person : NSObject <EKMappingProtocol>

@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *email;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, strong) Car *car;
@property (nonatomic, strong) NSArray *phones;
@property (nonatomic, strong) NSURL * socialURL;
@end

@interface Car : NSObject <EKMappingProtocol>

@property (nonatomic, copy)   NSString *model;
@property (nonatomic, copy)   NSString *year;
@property (nonatomic, strong) NSDate *createdAt;

@end

@interface Phone : NSObject <EKMappingProtocol>

@property (nonatomic, copy) NSString *DDI;
@property (nonatomic, copy) NSString *DDD;
@property (nonatomic, copy) NSString *number;

@end

@interface Native : NSObject <EKMappingProtocol>

@property (nonatomic, readwrite) NSInteger integerProperty;
@property (nonatomic, readwrite) NSUInteger unsignedIntegerProperty;
@property (nonatomic, readwrite) CGFloat cgFloatProperty;
@property (nonatomic, readwrite) double doubleProperty;
@property (nonatomic, readwrite) BOOL boolProperty;

@end
```

* Mapping becomes as simple as implementing single method

```objective-c

@implementation Person

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *genders = @{ @"male": @(GenderMale), @"female": @(GenderFemale) };
        [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^(NSString *key, id value) {
            return genders[value];
        } reverseBlock:^id(id value) {
           return [genders allKeysForObject:value].lastObject;
        }];
        [mapping mapKeyPath:@"socialURL" toProperty:@"socialURL"
             withValueBlock:[EKMappingBlocks urlMappingBlock]
               reverseBlock:[EKMappingBlocks urlReverseMappingBlock]];
        [mapping hasOne:[Car class] forKeyPath:@"car"];
        [mapping hasMany:[Phone class] forKeyPath:@"phones"];
    }];
}

@end

@implementation Car

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"model", @"year"]];
        [mapping mapKeyPath:@"created_at" toProperty:@"createdAt" withDateFormatter:[NSDateFormatter ek_formatterForCurrentThread]];
    }];
}

@end

@implementation Phone

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"number"]];
        [mapping mapPropertiesFromDictionary:@{
            @"ddi" : @"DDI",
            @"ddd" : @"DDD"
         }];
    }];
}

@end

@implementation Native

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[
         @"integerProperty", @"unsignedIntegerProperty", 
         @"cgFloatProperty", @"doubleProperty", 
         @"boolProperty"
        ]];
    }];
}

@end
```

* Converting a NSDictionary or NSArray to a object class or collection now becomes easy:

```objective-c
Person *person = [EKMapper objectFromExternalRepresentation:personRepresentation 
                                                withMapping:[Person objectMapping]];

NSArray *carsArray = [EKMapper arrayOfObjectsFromExternalRepresentation:carsRepresentation 
                                                            withMapping:[Car objectMapping]];
```

* Converting an object/collection to NSDictionary/NSArray:

```objective-c
NSDictionary *representation = [EKSerializer serializeObject:car withMapping:[Car objectMapping]];
NSArray *collectionRepresentation = [EKSerializer serializeCollection:cars withMapping:[Car objectMapping]];
```

* Filling an existent object:

Suppose you have something like this:

```objective-c
Person *person = [Person alloc] init]	
```

To fill an already instantiated object you can do this:

```objective-c
[EKMapper fillObject:person fromExternalRepresentation:personRepresentation withMapping:[Person objectMapping]];
```

### Swift

EasyMapping is partially compatible with Swift. [Here's detailed look](https://github.com/EasyMapping/EasyMapping/wiki/Swift-and-EasyMapping) at EasyMapping usage in Swift and current limitations.

### Convenience classes

EasyMapping provides two convenience base classes: EKObjectModel and EKManagedObjectModel, that implement EKMappingProtocol by default. If, for example, class Person would inherit from EKObjectModel, and implemented objectMapping method, all it would take to create Person instance from JSON representation would be:

```objective-c
NSDictionary * parsedPersonInfo = ...;
Person * person = [Person objectWithProperties:parsedPersonInfo];
```

And CoreData variant in case Person is EKManagedObjectModel subclass:

```objective-c
NSDictionary * parsedPersonInfo = ...;
Person * person = [Person objectWithProperties:parsedPersonInfo inContext:context];
```

Serializing to NSDictionary is even easier:
```objective-c
NSDictionary * info = [person serializedObject];
```

### CoreData

If you are using CoreData objects use `EKManagedObjectMapping` instead of `EKObjectMapping`. EasyMapping tries to speed up importing to database by scanning provided JSON and fetching all existing objects in batch. The more high level JSON will be provided, the more speed boost can be achieved.

### Recursive mappings

Sometimes you can encounter situation, where your JSON will contain objects with links to objects of the same type. Good example would be comments, and replies to comments, that have tree-like structure. Starting with 0.7.0 recursive mappings are fully supported by EasyMapping.

## Thanks

Thanks to: 

* [basitali](https://github.com/basitali) who added the fillObject functionality on EKMapper!
* [Alejandro](https://github.com/aleph7) who added CoreData support!
* [Philip Vasilchenko](https://github.com/ArtFeel) who added the ability to serialization/deserialization of scalar types!
* [Dany L'Hébreux](https://github.com/danylhebreux) who added the NSSet support!
* [Jack](https://github.com/Jack-s) who added mapFieldsFromMappingObject and mapFieldsFromArrayToPascalCase functionality
* [Yuri Kotov](https://github.com/advantis) and [Dmitriy](https://github.com/poteryaysya) which added a lot of performance improvements

## Requirements

* Xcode 6.3 and higher
* iOS 5 and higher
* Mac OS X 10.7 and higher
* ARC

## Installation

Using [CocoaPods](https://cocoapods.org):

	pod 'EasyMapping', '~> 0.15.0'

Using [Carthage](https://github.com/Carthage/Carthage):

    github "EasyMapping/EasyMapping"

Carthage uses dynamic frameworks, which require iOS 8.

## The idea

The idea came from:
* [RestKit's](https://github.com/RestKit/Restkit) mapping, its problem is that it doesn't transform
custom values (such as a string value to an enum)
* [Mantle's](https://github.com/github/Mantle) mapping, but you don't need to inherit from any class
