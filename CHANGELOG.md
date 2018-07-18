# Change Log
All notable changes to this project will be documented in this file.

# Next

## [0.22.1](https://github.com/lucasmedeirosleite/EasyMapping/releases/tag/0.22.1)

* Added support for recognizing structs as native types, for example `CLLocationCoordinate2D` - #168(thanks, @sebastianludwig)

## [0.22.0](https://github.com/lucasmedeirosleite/EasyMapping/releases/tag/0.22.0)

* Removed too strict generic constraints from `EKMapper` and `EKManagedObjectMapper` classes.

## [0.21.2](https://github.com/lucasmedeirosleite/EasyMapping/releases/tag/0.21.2)

* `EKSerializer` no longer implies that serializable objects need to conform to `EKMappingProtocol` or `EKManagedMappingProtocol`.

## [0.21.1](https://github.com/lucasmedeirosleite/EasyMapping/releases/tag/0.21.1)

* Fixed a bug in `EKSerializer` that prevented has one relationships from being properly serialized with non-nested keypaths.

## [0.21.0](https://github.com/lucasmedeirosleite/EasyMapping/releases/tag/0.21.0)

* Fixed potential buffer overflow when using scalar Objective-C properties(#155, #156).
* Added support for installation using Carthage and Swift Package Manager.
* `ignoreMissingFields` property now properly differentiates between a truly missing from JSON field and field, that contains null, which is turned into NSNull.null instance by NSJSONSerialization.
* `mapKeyPath:toPoperty:withDateFormatter` method now creates blocks, that return nil instead of `NSNull` if received value is not a NSString or NSDate. `NSNull` instance however is left untouched.

## [0.20.1](https://github.com/lucasmedeirosleite/EasyMapping/releases/tag/0.20.1)

* Added ability to ignore field during serialization - #148(thanks, @vladimirbebeshko)
* Improved types of arrays - #145(thanks, @Uncommon)
* EKRelationshipMapping has been made public for iOS target - #147(thanks, @dvs15)
* Fixed Xcode 8.3 warning in imports.

## [0.20.0](https://github.com/lucasmedeirosleite/EasyMapping/releases/tag/0.20.0)

This release requires iOS 8 / macOS 10.9 / tvOS 9.0 / watchOS 2.0 and higher.

#### New

* API was annotated with lightweight Objective-c generics and nullability annotations to be better imported in Swift.
* All relationship mappings, like `hasOne:forKeyPath:`, now return `EKRelationshipMapping` instead of void, and allow mapping customization via condition property.
* It's now possible to switch mappings based on passed representation, like so:

```objective-c
EKRelationshipMapping * relationship = [mapping hasMany:Dog.class forKeyPath:@"animals" forProperty:@"pets"];
relationship.mappingResolver = ^EKObjectMapping *(id representation){
    if ([representation[@"type"] isEqualToString:@"dog"]) {
        return [Dog objectMapping];
    } else {
        return [Wolf objectMapping];
    }
};
```

#### Breaking API

* `EKObjectMapping` `hasOneMappings` and `hasManyMappings` are now arrays instead of being dictionaries.
* `EKRelationshipMapping` now has  `mappingResolver` and `serializationResolver` properties instead of `objectClass` property of `EKMappingProtocol` type
* `NSDateFormatter` extension with `ek_dateFormatterForCurrentThread` is removed.

## [0.18.1](https://github.com/lucasmedeirosleite/EasyMapping/releases/tag/0.18.1)

### Fixed

* Crash, that happened when `EKCoreDataImporter` tried to import Swift NSManagedObject subclass, that did not have primaryKeyMapping, which led to calling valueForKeyPath method with nil.

## [0.18.0](https://github.com/lucasmedeirosleite/EasyMapping/releases/tag/0.18.0)

## New

* All API was annotated for nullability, allowing better interoperability with Swift
* Added `mapPropertiesFromUnderscoreToCamelCase:` method on `EKObjectMapping`, that allows mapping underscored JSON keypaths to camel-cased properties.

For example:

```objectivec
[mapping mapPropertiesFromUnderscoreToCamelCase:@[@"created_at",@"car_id"]];
```

will map `created_at` and `car_id` keypaths to `createdAt` and `carId` properties in your model.

## Fixed

* When using `mapKeyPath:toProperty:withValueBlock:` method and `ignoreMissingFields` property on `EKObjectMapping` is set to `YES`, value block will no longer be called, if value in JSON is nil

## Deprecations

* `NSDateFormatter` extension with `ek_formatterForCurrentThread` is deprecated and slated to be removed in release for Xcode 8, which drops support for iOS 7 and lower. This property is no longer useful, because `NSDateFormatter` is thread safe from iOS 7 and higher, and there's no reason to store `NSDateFormatter` in thread dictionary anymore.

## Removals

Following deprecated methods were removed:

* `serializedObject` on `EKManagedObjectModel`. Use `serializedObjectInContext:` instead.
* `mapKeyPath:toProperty:withDateFormat:` method on `EKObjectMapping`. Use `mapKeyPath:toProperty:withDateFormatter:` method instead.
