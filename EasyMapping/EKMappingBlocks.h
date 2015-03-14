//
//  EasyMapping
//
//  Copyright (c) 2012-2015 Lucas Medeiros.
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#if __has_feature(nullability) // Xcode 6.3+
#pragma clang assume_nonnull begin
#else
#define nullable
#define __nullable
#endif

typedef __nullable id(^EKMappingValueBlock)(NSString *key, __nullable id value);
typedef __nullable id(^EKMappingReverseBlock)(__nullable id value);

typedef __nullable id(^EKManagedMappingValueBlock)(NSString * key, __nullable id value, NSManagedObjectContext * context);
typedef __nullable id(^EKManagedMappingReverseValueBlock)(__nullable id value, NSManagedObjectContext * context);

@interface EKMappingBlocks: NSObject

+ (EKMappingValueBlock)urlMappingBlock;
+ (EKMappingReverseBlock)urlReverseMappingBlock;

@end

#if __has_feature(nullability)
#pragma clang assume_nonnull end
#endif

