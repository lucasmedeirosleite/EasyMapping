//
//  EKMapperSpec.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 23/02/13.
//  Copyright 2013 EasyKit. All rights reserved.
//

#import "Kiwi.h"
#import "CMFixture.h"
#import "CMFactory.h"
#import "EasyMapping.h"
#import "MappingProvider.h"
#import "Person.h"
#import "Car.h"
#import "Phone.h"
#import "Address.h"
#import "Native.h"

SPEC_BEGIN(EKMapperSpec)

describe(@"EKMapper", ^{
    
    describe(@"class methods", ^{
       
        specify(^{
            [[EKMapper should] respondToSelector:@selector(objectFromExternalRepresentation:withMapping:)];
        });
        
        specify(^{
            [[EKMapper should] respondToSelector:@selector(arrayOfObjectsFromExternalRepresentation:withMapping:)];
        });
        
    });
    
    describe(@".objectFromExternalRepresentation:withMapping:", ^{
       
        context(@"a simple object", ^{
        
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"Car"];
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carMapping]];
            });
            
            specify(^{
                [car shouldNotBeNil];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
            });
            
        });
        
        context(@"with root key", ^{
            
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithRoot"];
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carWithRootKeyMapping]];
                externalRepresentation = [externalRepresentation objectForKey:@"car"];
            });
            
            specify(^{
                [car shouldNotBeNil];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
            });
            
        });
        
        context(@"with nested information", ^{
            
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithNestedAttributes"];
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carNestedAttributesMapping]];
            });
            
            specify(^{
                [car shouldNotBeNil];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:[[externalRepresentation objectForKey:@"information"] objectForKey:@"year"]];
            });
            
        });
        
        context(@"with dateformat", ^{
            
            __block Car *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithDate"];
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carWithDateMapping]];
            });
            
            specify(^{
                [car shouldNotBeNil];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
            });
            
            it(@"should populate createdAt field with a NSDate", ^{
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                format.dateFormat = @"yyyy-MM-dd";
                NSDate *expectedDate = [format dateFromString:[externalRepresentation objectForKey:@"created_at"]];
                [[car.createdAt should] equal:expectedDate];
                
            });
            
        });
        
        context(@"with valueBlock", ^{
            
            context(@"when male", ^{
            
                __block Person *person;
                __block NSDictionary *externalRepresentation;
                
                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"Male"];
                    person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personWithOnlyValueBlockMapping]];
                });
                
                specify(^{
                    [[theValue(person.gender) should] equal:theValue(GenderMale)];
                });
                
            });
            
            context(@"when female", ^{
                
                __block Person *person;
                __block NSDictionary *externalRepresentation;
                
                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"Female"];
                    person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personWithOnlyValueBlockMapping]];
                });
                
                specify(^{
                    [[theValue(person.gender) should] equal:theValue(GenderFemale)];
                });
                
            });
            
            context(@"with custom object returned", ^{
                
                __block Address *address;
                __block NSDictionary *externalRepresentation;
                
                beforeEach(^{
                    externalRepresentation = [CMFixture buildUsingFixture:@"Address"];
                    address = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider addressMapping]];
                });
                
                specify(^{
                    [address shouldNotBeNil];
                });
                
                specify(^{
                    [address.location shouldNotBeNil];
                });
                
            });
            
        });
        
        context(@"with hasOne mapping", ^{
            
            __block Person *person;
            __block Car *expectedCar;
            
            beforeEach(^{
               
                CMFactory *carFactory = [CMFactory forClass:[Car class]];
                [carFactory addToField:@"model" value:^{
                    return @"i30";
                }];
                [carFactory addToField:@"year" value:^{
                    return @"2013";
                }];
                expectedCar = [carFactory build];
                
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
                
            });
            
            specify(^{
                [person.car shouldNotBeNil];
            });
            
            specify(^{
                [[person.car.model should] equal:expectedCar.model];
            });
            
            specify(^{
                [[person.car.year should] equal:expectedCar.year];
            });
            
        });
        
        context(@"with hasOne mapping with different names", ^{
            __block Car * expectedCar;
            __block Person * person;
            beforeEach(^{
                expectedCar = [[Car alloc] init];
                expectedCar.model = @"i30";
                expectedCar.year = @"2013";
                EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
                [mapping hasOneMapping:[MappingProvider carMapping] forKey:@"vehicle" forField:@"car"];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithDifferentNaming"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
            });
            
            specify(^{
                [person.car shouldNotBeNil];
            });

            specify(^{
                [[person.car should] beMemberOfClass:[Car class]];
            });
            
            specify(^{
                [[person.car.model should] equal:@"i30"];
            });
            
            specify(^{
                [[person.car.year should] equal:@"2013"];
            });

        });
        
        context(@"with hasMany mapping", ^{
            
            __block Person *person;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
            
        });
        
        context(@"with hasMany mapping with different names", ^{
            
            __block Person * person;
            
            beforeEach(^{
                EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
                [mapping hasManyMapping:[MappingProvider phoneMapping] forKey:@"cellphones" forField:@"phones"];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithDifferentNaming"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
            
            specify(^{
                [[person.phones.lastObject should] beMemberOfClass:[Phone class]];
            });
            
            specify(^{
                Phone * lastPhone = person.phones.lastObject;
                
                [[lastPhone.number should] equal:@"2222-222"];
            });
        });
        
        context(@"with native properties", ^{
            
            __block Native *native;
            
            beforeEach(^{
                EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:[Native class]];
                [mapping mapFieldsFromArray:@[
                 /*@"charProperty", @"unsignedCharProperty",*/ @"shortProperty", @"unsignedShortProperty", @"intProperty", @"unsignedIntProperty",
                 @"integerProperty", @"unsignedIntegerProperty", @"longProperty", @"unsignedLongProperty", @"longLongProperty",
                 @"unsignedLongLongProperty", @"floatProperty", @"cgFloatProperty", @"doubleProperty", @"boolProperty"
                ]];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Native"];
                native = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
            });
            
            specify(^{
                [[theValue(native.charProperty) should] equal:theValue('c')];
            });
            
            specify(^{
                [[theValue(native.unsignedCharProperty) should] equal:theValue('u')];
            });
            
            specify(^{
                [[theValue(native.shortProperty) should] equal:theValue(1)];
            });
            
            specify(^{
                [[theValue(native.unsignedShortProperty) should] equal:theValue(2)];
            });
            
            specify(^{
                [[theValue(native.intProperty) should] equal:theValue(3)];
            });
            
            specify(^{
                [[theValue(native.unsignedIntProperty) should] equal:theValue(4)];
            });
            
            specify(^{
                [[theValue(native.integerProperty) should] equal:theValue(5)];
            });
            
            specify(^{
                [[theValue(native.unsignedIntegerProperty) should] equal:theValue(6)];
            });
            
            specify(^{
                [[theValue(native.longProperty) should] equal:theValue(7)];
            });
            
            specify(^{
                [[theValue(native.unsignedLongProperty) should] equal:theValue(8)];
            });
            
            specify(^{
                [[theValue(native.longLongProperty) should] equal:theValue(9)];
            });
            
            specify(^{
                [[theValue(native.unsignedLongLongProperty) should] equal:theValue(10)];
            });
            
            specify(^{
                [[theValue(native.floatProperty) should] equal:theValue(11.1)];
            });
            
            specify(^{
                [[theValue(native.cgFloatProperty) should] equal:theValue(12.2)];
            });
            
            specify(^{
                [[theValue(native.doubleProperty) should] equal:theValue(13.3)];
            });
            
            specify(^{
                [[theValue(native.boolProperty) should] beYes];
            });
            
        });
        
    });
    
    describe(@".arrayOfObjectsFromExternalRepresentation:withMapping:", ^{
       
        __block NSArray *carsArray;
        __block NSArray *externalRepresentation;
        
        beforeEach(^{
            externalRepresentation = [CMFixture buildUsingFixture:@"Cars"];
            carsArray = [EKMapper arrayOfObjectsFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carMapping]];
        });
        
        specify(^{
            [carsArray shouldNotBeNil];
        });
        
        specify(^{
            [[carsArray should] haveCountOf:[externalRepresentation count]];
        });
        
    });
    
});

SPEC_END


