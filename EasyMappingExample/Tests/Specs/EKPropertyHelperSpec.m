//
//  EKPropertyHelperSpec.m
//  EasyMappingExample
//
//  Created by Andrew Romanov on 27.03.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "Kiwi.h"
#import "CMFactory.h"
#import "EKPropertyHelper.h"
#import "EasyMapping.h"
#import "Native.h"
#import "CMFixture.h"
#import "MappingProvider.h"


SPEC_BEGIN(EKPropertyHelperSpec)

describe(@"EKPropertyHelper", ^{
	context(@"native properties", ^{
		__block Native *native;
		beforeEach(^{
			NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Native"];
			native = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[Native objectMapping]];
		});
		
		context(@"detect native properties", ^{
			specify(^{
				EKObjectMapping* mapping = [Native objectMapping];
				[mapping.propertyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
					EKPropertyMapping* fieldMapping = obj;
					[[@([EKPropertyHelper propertyNameIsScalar:fieldMapping.property fromObject:native]) should] equal:@(YES)];
				}];
			});
			specify(^{
				[[@([EKPropertyHelper propertyNameIsScalar:@"boolProperty" fromObject:native]) should] equal:@(YES)];
			});
		});
	});
});

SPEC_END