//
//  EKObjectMappingClassMutationSpec.m
//  EasyMappingExample
//
//  Created by Roman Petryshen on 08/05/15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

#import <CMFactory/CMFixture.h>
#import "Kiwi.h"
#import "EasyMapping.h"
#import "Option.h"
#import "BooleanOption.h"
#import "AmountOption.h"

SPEC_BEGIN(EKObjectMappingClassMutationSpec)


    describe(@"EKMapper", ^{

        context(@"testing mapping", ^{
            EKObjectMapping *mapping = [Option objectMapping];

            it(@"should be able to mutate class", ^{
                [[@([mapping canMutateClass]) should] beTrue];
            });
        });

        context(@"using mapping with class mutation block", ^{

            NSArray *externalRepresentation = [CMFixture buildUsingFixture:@"Options"];

            NSArray *items = [EKMapper arrayOfObjectsFromExternalRepresentation:externalRepresentation
                                                                    withMapping:[Option objectMapping]];

            it(@"should map two items", ^{
                [[theValue(items.count) should] equal:@2];
            });


            it(@"should choose correct(mutated) classes", ^{
                id item1 = items.firstObject;
                [[@([item1 isMemberOfClass:[BooleanOption class]]) should] beTrue];

                id item2 = items.lastObject;
                [[@([item2 isMemberOfClass:[AmountOption class]]) should] beTrue];
            });


            it(@"should map additional fields", ^{

                BooleanOption *item1 = (BooleanOption *) items.firstObject;
                [[item1.optionId should] equal:@1];
                [[item1.title should] equal:@"Bool option"];
                [[@(item1.type) should] equal:@(OptionTypeBoolean)];

                AmountOption *item2 = (AmountOption *) items.lastObject;
                [[item2.optionId should] equal:@2];
                [[item2.title should] equal:@"Amount option"];
                [[item2.min should] equal:@5];
                [[item2.max should] equal:@10];
                [[@(item2.type) should] equal:@(OptionTypeAmount)];
            });
        });
    });

SPEC_END
