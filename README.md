# EasyMapping

An easy way to unmarshall a Dictionary of attributes (which came from JSON, XML or just a NSDictionary) into a Class and vice versa.

##Contact:

Developed by [Lucas Medeiros](https://www.twitter.com/aspmedeiros)
E-mail: lucastoc@gmail.com

## Development requirements

* Cocoapods - https://github.com/CocoaPods/CocoaPods

## Install cocoapods

To install cocoapods you will need ruby.

	gem install cocoapods
	
More information about cocoapods:

* https://github.com/CocoaPods/CocoaPods
* http://nsscreencast.com/episodes/5-cocoapods

## Cocoapods

Add the dependency to your `Podfile`:

```ruby
platform :ios

...

pod 'EasyMapping', '0.1.0'

```
Run `pod install` to install the dependencies.

## Usage

* Supose you have these classes:

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

Supose you have something like this:

```objective-c
	
Person *person = [Person alloc] init]	
	
```

To fill an already instantiated object you can do this:

```objective-c

[EKMapper fillObject:person fromExternalRepresentation:personRepresentation withMapping:[Mappings personMapping]];

```

* See the specs code

## Thanks

Thanks to [basitali](https://github.com/basitali) who added the fillObject functionality on EKMapper!

## Requirements

`EasyMapping` requires iOS 5.x or greater.

Usage is provided under the [MIT License](http://http://opensource.org/licenses/mit-license.php).  See LICENSE for the full details.

## The idea

The idea came from:
* [RestiKit's](https://github.com/RestKit/Restkit) mapping, its problem is that it doesn't transform
custom values (such as a string value to an enum)
* [Mantle's](https://github.com/github/Mantle) mapping, but you don't need to inherit from any class

