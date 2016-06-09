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
#import "Plane.h"
#import "Seaplane.h"
#import "Alien.h"
#import "Finger.h"
#import "Cat.h"
#import "CommentObject.h"
#import "MutableFoundationClass.h"

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
                externalRepresentation = externalRepresentation[@"data"][@"car"];
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
            
            specify(^{
                [[theValue(car.carId) should] equal:theValue(1)];
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
        
        context(@"Using mapping blocks", ^{
           
            __block Person *person;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                [Car registerMapping:[MappingProvider carMapping]];
                [Phone registerMapping:[MappingProvider phoneMapping]];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
            });
            
            specify(^{
                [[person.socialURL should] equal:[NSURL URLWithString:@"https://www.twitter.com/EasyMapping"]];
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
                [Car registerMapping:[MappingProvider carMapping]];
                [Phone registerMapping:[MappingProvider phoneMapping]];
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
                [Car registerMapping:[MappingProvider carMapping]];
                [mapping hasOne:Car.class forKeyPath:@"vehicle" forProperty:@"car"];
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
                [Phone registerMapping:[MappingProvider phoneMapping]];
                [mapping hasMany:Phone.class forKeyPath:@"cellphones" forProperty:@"phones"];
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
		 
		 context(@"with hasMany mapping NULL in representation", ^{
			 __block Person* person;
			 
			 beforeEach(^{
				 NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithNullPhones"];
				 person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
			 });
			 
			 specify(^{
				 [[person.phones should] beNil];
			 });
			 
			 specify(^{
				 [[person shouldNot] beNil];
			 });
			 
			 specify(^{
				 [[person.car shouldNot] beNil];
			 });
		 });

        context(@"with hasMany mapping and not incrementalData", ^{
            __block Person* person;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
                externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithOtherPhones"];
                person = [EKMapper fillObject:person fromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
            });
            
            specify(^{
                [[person shouldNot] beNil];
            });

            specify(^{
                [[person.phones shouldNot] beNil];
            });

            specify(^{
                [[person.phones should] haveCountOf:2];
            });
        });

        context(@"with hasMany mapping and incrementalData", ^{
            __block Person* person;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
                externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithOtherPhones"];
                EKObjectMapping *mapping = [MappingProvider personMapping];
                mapping.incrementalData = YES;
                person = [EKMapper fillObject:person fromExternalRepresentation:externalRepresentation
                                  withMapping:mapping];
            });
            
            specify(^{
                [[person shouldNot] beNil];
            });
            
            specify(^{
                [[person.phones shouldNot] beNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:4];
            });
        });

        context(@"with hasMany mapping empty and not incrementalData", ^{
            __block Person* person;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
                externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithZeroPhones"];
                person = [EKMapper fillObject:person fromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
            });
            
            specify(^{
                [[person shouldNot] beNil];
            });
            
            specify(^{
                [[person.phones shouldNot] beNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:0];
            });
        });
        
        context(@"with hasMany mapping empty and incrementalData", ^{
            __block Person* person;
            
            beforeEach(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
                externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithZeroPhones"];
                EKObjectMapping *personMapping = [MappingProvider personMapping];
                personMapping.incrementalData = YES;
                person = [EKMapper fillObject:person fromExternalRepresentation:externalRepresentation withMapping:personMapping];
            });
            
            specify(^{
                [[person shouldNot] beNil];
            });
            
            specify(^{
                [[person.phones shouldNot] beNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
        });
        
		 context(@"with hasOne mapping NULL in representation", ^{
			 __block Person* person;
			 
			 beforeEach(^{
				 NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithNullCar"];
				 person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider personMapping]];
			 });
			 
			 specify(^{
				 [[person.phones shouldNot] beNil];
			 });
			 
			 specify(^{
				 [[person shouldNot] beNil];
			 });
			 
			 specify(^{
				 [[person.car should] beNil];
			 });
		 });

        context(@"with date mapping NULL in representation", ^{
            __block Car* car;

            beforeEach(^{
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"CarWithDate"];
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carWithDateMapping]];

                NSDictionary *updatedRepresentation = [CMFixture buildUsingFixture:@"CarWithAttributesRemoved"];
                car = [EKMapper fillObject:car fromExternalRepresentation:updatedRepresentation withMapping:[MappingProvider carWithDateMapping]];
            });

            specify(^{
                [[car.year shouldNot] beNil];
            });

            specify(^{
                [[car.model should] beNil];
            });
            
            specify(^{
                [[car.createdAt should] beNil];
            });
        });
        
        context(@"with native properties", ^{
            
            __block Native *native;
            
            beforeEach(^{
                EKObjectMapping * mapping = [Native objectMapping];
                NSDictionary * externalRepresentation = [CMFixture buildUsingFixture:@"Native"];
                native = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
            });
            
            specify(^{
                [[@(native.charProperty) should] equal:@('c')];
            });
            
            specify(^{
                [[@(native.unsignedCharProperty) should] equal:@('u')];
            });
            
            specify(^{
                [[@(native.shortProperty) should] equal:@(1)];
            });
            
            specify(^{
                [[@(native.unsignedShortProperty) should] equal:@(2)];
            });
            
            specify(^{
                [[@(native.intProperty) should] equal:@(3)];
            });
            
            specify(^{
                [[@(native.unsignedIntProperty) should] equal:@(4)];
            });
            
            specify(^{
                [[@(native.integerProperty) should] equal:@(5)];
            });
            
            specify(^{
                [[@(native.unsignedIntegerProperty) should] equal:@(6)];
            });
            
            specify(^{
                [[@(native.longProperty) should] equal:@(7)];
            });
            
            specify(^{
                [[@(native.unsignedLongProperty) should] equal:@(8)];
            });
            
            specify(^{
                [[@(native.longLongProperty) should] equal:@(9)];
            });
            
            specify(^{
                [[@(native.unsignedLongLongProperty) should] equal:@(10)];
            });
            
            specify(^{
                [[@(native.floatProperty) should] equal:@(11.1f)];
            });
            
            specify(^{
                [[@(native.cgFloatProperty) should] equal:12.2f withDelta:0.001];
            });
            
            specify(^{
                [[@(native.doubleProperty) should] equal:@(13.3)];
            });
            
            specify(^{
                [[@(native.boolProperty) should] beYes];
            });
            
            context(@"with a native propertie that is null", ^{
                
                __block Cat *cat;
                
                beforeEach(^{
                    EKObjectMapping *catMapping = [MappingProvider nativeMappingWithNullPropertie];
                    NSDictionary *values = @{ @"age": [NSNull null] };
                    cat = [EKMapper objectFromExternalRepresentation:values withMapping:catMapping];
                });
                
                specify(^{
                    [[cat shouldNot] beNil];
                });
                
                specify(^{
                    [[theValue(cat.age) should] equal:theValue(0)];
                });
                
            });
            
        });
        
    });
    
    describe(@".arrayOfObjectsFromExternalRepresentation:withMapping:", ^{

        context(@"a simple array", ^{
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

        context(@"with null items", ^{
            __block NSArray *carsArray;
            __block NSArray *externalRepresentation;

            beforeEach(^{
                externalRepresentation = [CMFixture buildUsingFixture:@"CarsWithNullItem"];
                carsArray = [EKMapper arrayOfObjectsFromExternalRepresentation:externalRepresentation withMapping:[MappingProvider carMapping]];
            });

            specify(^{
                [carsArray shouldNotBeNil];
            });

            specify(^{
                [[carsArray should] haveCountOf:[externalRepresentation count] - 1];
            });
        });
        
    });
    
    context(@"with hasMany mapping with set", ^{
        
        __block Plane * plane;
        
        beforeEach(^{
            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Plane"];
            EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:[Plane class]];
            [Person registerMapping:[MappingProvider personMapping]];
            [mapping hasMany:Person.class forKeyPath:@"persons"];
            [mapping hasMany:Person.class forKeyPath:@"pilots"];
            [mapping hasMany:Person.class forKeyPath:@"stewardess"];
            [mapping hasMany:Person.class forKeyPath:@"stars"];
            plane = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
        });
        
        specify(^{
            [plane.persons shouldNotBeNil];
        });
        
        specify(^{
            [[plane.persons should] beKindOfClass:[NSSet class]];
        });
        
        specify(^{
            [[plane.pilots should] beKindOfClass:[NSMutableSet class]];
        });

        specify(^{
            [[plane.stewardess should] beKindOfClass:[NSOrderedSet class]];
        });

        specify(^{
            [[plane.stars should] beKindOfClass:[NSMutableOrderedSet class]];
        });

    });
    
    context(@"with hasMany mapping with set and different key name", ^{
        
        __block Seaplane * seaplane;
        
        beforeEach(^{
            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Plane"];
            EKObjectMapping * mapping = [[EKObjectMapping alloc] initWithObjectClass:[Seaplane class]];
            [Person registerMapping:[MappingProvider personMapping]];
            [mapping hasMany:[Person class] forKeyPath:@"persons" forProperty:@"passengers"];
            seaplane = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:mapping];
        });
        
        specify(^{
            [seaplane.passengers shouldNotBeNil];
        });

        specify(^{
            [[seaplane.passengers should] beKindOfClass:[NSSet class]];
        });
        
    });
    
    context(@"with hasMany mapping with NSMutableArray", ^{
        
        __block Alien *alien;
        
        beforeEach(^{
            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Alien"];
            alien = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[Alien objectMapping]];
        });
        
        specify(^{
            [alien.fingers shouldNotBeNil];
        });
        
        specify(^{
            [[alien.fingers should] beKindOfClass:[NSMutableArray class]];
        });
    
    });
    
    context(@"with recursive hasMany mapping", ^{
        
        __block NSArray * comments = nil;
        
        beforeEach(^{
            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"CommentsRecursive"];
            [CommentObject registerMapping:[CommentObject objectMapping]];
            comments = [EKMapper arrayOfObjectsFromExternalRepresentation:externalRepresentation[@"comments"]
                                                             withMapping:[CommentObject objectMapping]];
        });
        
        it(@"should contain comments", ^{
            [[@(comments.count) should] equal:@2];
        });
        
        it(@"should contain subcomments", ^{
            NSArray * subcomments = [(CommentObject *)[comments firstObject] subComments];
            
            [[@([subcomments count]) should] equal:@1];
            [[subcomments.firstObject should] beKindOfClass:[CommentObject class]];
        });
        
        it(@"should contain sub sub comments", ^{
            NSArray * subcomments = [(CommentObject *)[comments firstObject] subComments];
            
            NSArray * subsubComments = [(CommentObject *)subcomments.firstObject subComments];
            
            [[@([subsubComments count]) should] equal:@1];
            [[subsubComments.firstObject should] beKindOfClass:[CommentObject class]];
            
            CommentObject * comment = subsubComments.firstObject;
            
            [[comment.name should] equal:@"Bob"];
            [[comment.message should] equal:@"It's a TRAP!"];
            [[comment.subComments should] beNil];
        });
        
    });
    
    context(@"with recursive hasOne mapping", ^{
        __block Person * person = nil;
        
        beforeEach(^{
            NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonRecursive"];
            [Person registerMapping:[MappingProvider personWithRelativeMapping]];
            person = [EKMapper objectFromExternalRepresentation:externalRepresentation
                                                      withMapping:[MappingProvider personWithRelativeMapping]];
        });
        
        it(@"should be a person", ^{
            [[person should] beKindOfClass:[Person class]];
        });
        
        it(@"should contain relative", ^{
            [[person.relative should] beKindOfClass:[Person class]];
        });
        
        it(@"should have correct values", ^{
            [[person.relative.name should] equal:@"Loreen"];
            [[person.relative.email should] equal:@"loreen@gmail.com"];
            [[@(person.relative.gender) should] equal:@(GenderFemale)];
        });
        
        it(@"should contain list of children", ^{
            [[person.children should] beKindOfClass:[NSArray class]];
        });
        
        it(@"should have 2 children", ^{
            [[theValue(person.children.count) should] equal:theValue(2)];
        });
        
        it(@"should contain child", ^{
            [[[person.children objectAtIndex:0] should] beKindOfClass:[Person class]];
        });
        
        it(@"should have a brother", ^{
            Person * brother = [person.children.firstObject relative];
            
            [[brother.name should] equal:@"Alexey"];
        });
        
    });
    
    context(@"hasOneMapping with several non nested keys", ^{
        __block Person * person = nil;
        
        beforeEach(^{
            NSDictionary * externalRepresentation = [CMFixture buildUsingFixture:@"PersonNonNested"];
            [Person registerMapping:[MappingProvider personNonNestedMapping]];
            person = [EKMapper objectFromExternalRepresentation:externalRepresentation
                                                    withMapping:[MappingProvider personNonNestedMapping]];
        });
        
        it(@"should contain car", ^{
            [[person.car should] beKindOfClass:[Car class]];
        });
        
        it(@"should have correct name", ^{
            [[person.name should] equal:@"Lucas"];
        });
        
        it(@"should have correct car properties", ^{
            [[@(person.car.carId) should] equal:@3];
            [[person.car.model should] equal:@"i30"];
            [[person.car.year should] equal:@"2013"];
        });
    });
    
    describe(@"#mapKeyPath:toProperty should convert properties to mutable values, if properties are mutable", ^{
        
        __block MutableFoundationClass * instance = nil;
        
        beforeEach(^{
            
            NSDictionary * externalRepresentation = [CMFixture buildUsingFixture:@"MutableFoundationClass"];
            instance = [[MutableFoundationClass alloc] initWithProperties:externalRepresentation];
        });
        
        it(@"should have mutable array", ^{
            [[instance.array should] beKindOfClass:[NSMutableArray class]];
        });
        
        it(@"should have mutable dictionary", ^{
           [[[instance dictionary] should] beKindOfClass:[NSMutableDictionary class]];
            [[theBlock(^{
                instance.dictionary[@"it's really mutable"] = @"";
            }) shouldNot] raise];
        });
        
        it(@"should have mutable set", ^{
            [[[instance mutableSet] should] beKindOfClass:[NSMutableSet class]];
        });
        
        it(@"should have mutable ordered set", ^{
            [[[instance mutableOrderedSet] should] beKindOfClass:[NSMutableOrderedSet class]];
        });
        
        it(@"should have set", ^{
            [[[instance set] should] beKindOfClass:[NSSet class]];
        });
        
        it(@"should have ordered set", ^{
            [[[instance orderedSet] should] beKindOfClass:[NSOrderedSet class]];
        });
        
    });
});

SPEC_END


