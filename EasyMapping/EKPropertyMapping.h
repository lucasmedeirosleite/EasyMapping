//
//  EasyMapping
//
//  Copyright (c) 2012-2014 Lucas Medeiros.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "EKMappingBlocks.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `EKPropertyMapping` is a class, that represents relation between representation of a single field in JSON and objective-c model property.
 */

@interface EKPropertyMapping : NSObject

/**
 Path to field in JSON, that will be later used with `valueForKeyPath:` method.
 */
@property (nonatomic, strong) NSString *keyPath;

/**
 Name of the property, which will be receiving value.
 */
@property (nonatomic, strong) NSString *property;

/**
 Optional block to transform JSON value into objective-C object.
 */
@property (nonatomic, strong, nullable) EKMappingValueBlock valueBlock;

/**
 Optional block to serialize objective-c object into JSON representation.
 */
@property (nonatomic, strong, nullable) EKMappingReverseBlock reverseBlock;

/**
 Optional block to transform JSON value into CoreData object.
 */
@property (nonatomic, strong, nullable) EKManagedMappingValueBlock managedValueBlock;

/**
 Optional block to serialize CoreData object into JSON representation.
 */
@property (nonatomic, strong, nullable) EKManagedMappingReverseValueBlock managedReverseBlock;

@end

NS_ASSUME_NONNULL_END
