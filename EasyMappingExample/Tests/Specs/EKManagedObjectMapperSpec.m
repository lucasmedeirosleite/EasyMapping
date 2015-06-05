//
//  EKManagedObjectMapperSpec.m
//  EasyMappingCoreDataExample
//
//  Created by Alejandro Isaza on 2013-03-20.
//
//

#import "Kiwi.h"
#import "CMFixture.h"
#import "CMFactory.h"
#import "EasyMapping.h"
#import "ManagedMappingProvider.h"
#import "ManagedPerson.h"
#import "ManagedCar.h"
#import "ManagedPhone.h"
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>
#import "EKManagedObjectMapper.h"

SPEC_BEGIN(EKManagedObjectMapperSpec)

describe(@"EKManagedObjectMapper", ^{
    
    beforeEach(^{
        [MagicalRecord setDefaultModelFromClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });
    
    describe(@"class methods", ^{
        
        specify(^{
            [[EKManagedObjectMapper should] respondToSelector:@selector(objectFromExternalRepresentation:withMapping:inManagedObjectContext:)];
        });
        
        specify(^{
            [[EKManagedObjectMapper should] respondToSelector:@selector(arrayOfObjectsFromExternalRepresentation:withMapping:inManagedObjectContext:)];
        });
        
    });
    
    describe(@".objectFromExternalRepresentation:withMapping:", ^{
        
        context(@"a simple object", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedCar *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                externalRepresentation = [CMFixture buildUsingFixture:@"Car"];
                car = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carMapping] inManagedObjectContext:moc];
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
        
        context(@"with existing object", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedCar *oldCar;
            __block ManagedCar *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_context];
                
                oldCar = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ManagedCar class])
                                                       inManagedObjectContext:moc];
                oldCar.carID = @(1);
                oldCar.year = @"1980";
                oldCar.model = @"";
                [moc MR_saveOnlySelfAndWait];
                
                externalRepresentation = @{
                    @"id": @(1),
                    @"model": @"i30",
                    @"year": @"2013"
                };
                
                car = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carMapping] inManagedObjectContext:moc];
            });
            
            specify(^{
                [car shouldNotBeNil];
            });
            
            specify(^{
                [[car should] equal:oldCar];
            });
            
            specify(^{
                [[car.carID should] equal:oldCar.carID];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
            });
            
            specify(^{
                [[[ManagedCar MR_findAll] should] haveCountOf:1];
            });
        });
        
        context(@"don't clear missing values", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedCar *oldCar;
            __block ManagedCar *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                
                oldCar = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ManagedCar class]) inManagedObjectContext:moc];
                oldCar.carID = @(1);
                oldCar.year = @"1980";
                oldCar.model = @"";
                oldCar.createdAt = [NSDate date];
                
                [moc save:nil];
                
                externalRepresentation = @{ @"id": @(1), @"model": @"i30", };
                car = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carWithDateMapping] inManagedObjectContext:moc];
            });
            
            specify(^{
                [[car.carID should] equal:oldCar.carID];
            });
            
            specify(^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            specify(^{
                [[car.year should] equal:oldCar.year];
            });

            specify(^{
                [[car.createdAt should] equal:oldCar.createdAt];
            });

            specify(^{
                [[[ManagedCar MR_findAll] should] haveCountOf:1];
            });
            
        });

        context(@"replaces explicitly nil attributes", ^{

            __block NSManagedObjectContext* moc;
            __block ManagedCar *oldCar;
            __block ManagedCar *car;
            __block NSDictionary *externalRepresentation;

            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];

                oldCar = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ManagedCar class]) inManagedObjectContext:moc];
                oldCar.carID = @(1);
                oldCar.year = @"1980";
                oldCar.model = @"";
                oldCar.createdAt = [NSDate date];

                [moc save:nil];

                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithAttributesRemoved"];
                car = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carWithDateMapping] inManagedObjectContext:moc];
            });

            specify(^{
                [[car.carID should] equal:oldCar.carID];
            });

            specify(^{
                [[car.model should] beNil];
            });

            specify(^{
                [[car.year should] equal:oldCar.year];
            });

            specify(^{
                [[car.createdAt should] beNil];
            });

            specify(^{
                [[[ManagedCar MR_findAll] should] haveCountOf:1];
            });

        });

        context(@"with root key", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedCar *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithRoot"];
                car = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carWithRootKeyMapping] inManagedObjectContext:moc];
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
            
            __block NSManagedObjectContext* moc;
            __block ManagedCar *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithNestedAttributes"];
                car = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carNestedAttributesMapping] inManagedObjectContext:moc];
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
            
            __block NSManagedObjectContext* moc;
            __block ManagedCar *car;
            __block NSDictionary *externalRepresentation;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                externalRepresentation = [CMFixture buildUsingFixture:@"CarWithDate"];
                car = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carWithDateMapping] inManagedObjectContext:moc];
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
        
        context(@"with hasOne mapping", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedPerson *person;
            __block ManagedCar *expectedCar;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                
                expectedCar = [ManagedCar MR_createEntity];
                expectedCar.model = @"i30";
                expectedCar.year = @"2013";
                
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider personMapping] inManagedObjectContext:moc];
                
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
        
        context(@"with hasMany mapping", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedPerson *person;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider personMapping] inManagedObjectContext:moc];
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
            
        });
        
    });
    
    describe(@".objectFromExternalRepresentation:withMapping:incrementalData:", ^{
        context(@"with hasMany mapping", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedPerson *person;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                EKManagedObjectMapping * personMapping = [ManagedMappingProvider personMapping];
                personMapping.incrementalData = YES;
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation
                                                                     withMapping:personMapping
                                                          inManagedObjectContext:moc];
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
            
        });

        context(@"with hasMany mapping and no incremental data", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedPerson *person;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider personMapping] inManagedObjectContext:moc];
                
                externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithOtherPhones"];
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider personMapping] inManagedObjectContext:moc];
                
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
            
        });
        context(@"with hasMany mapping and incremental data", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedPerson *person;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                EKManagedObjectMapping * personMapping = [ManagedMappingProvider personMapping];
                personMapping.incrementalData = YES;
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:personMapping inManagedObjectContext:moc];
                
                externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithOtherPhones"];
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:personMapping inManagedObjectContext:moc];
                
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:4];
            });
            
        });
        context(@"with hasMany mapping empty and not incremental data", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedPerson *person;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider personMapping] inManagedObjectContext:moc];
                
                externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithZeroPhones"];
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider personMapping] inManagedObjectContext:moc];
                
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:0];
            });
            
        });
        context(@"with hasMany mapping empty and incremental data", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedPerson *person;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"Person"];
                EKManagedObjectMapping * personMapping = [ManagedMappingProvider personMapping];
                personMapping.incrementalData = YES;
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:personMapping inManagedObjectContext:moc];
                
                externalRepresentation = [CMFixture buildUsingFixture:@"PersonWithZeroPhones"];
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation withMapping:personMapping inManagedObjectContext:moc];
                
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
            });
            
        });

        context(@"with recursive mapping", ^{
            
            __block NSManagedObjectContext* moc;
            __block ManagedPerson *person;
            
            beforeEach(^{
                moc = [NSManagedObjectContext MR_defaultContext];
                NSDictionary *externalRepresentation = [CMFixture buildUsingFixture:@"PersonRecursive"];
                EKManagedObjectMapping * personMapping = [ManagedMappingProvider personMapping];
                personMapping.incrementalData = YES;
                person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation
                                                                     withMapping:personMapping
                                                          inManagedObjectContext:moc];
            });

            it(@"should be a person", ^{
                [[person should] beKindOfClass:[ManagedPerson class]];
            });
            
            it(@"should contain relative", ^{
                [[person.relative should] beKindOfClass:[ManagedPerson class]];
            });
            
            it(@"should have correct values", ^{
                [[person.relative.name should] equal:@"Loreen"];
                [[person.relative.email should] equal:@"loreen@gmail.com"];
                [[person.relative.gender should] equal:@"female"];
            });

            it(@"should contain list of children", ^{
                [[person.children should] beKindOfClass:[NSSet class]];
            });
            
            it(@"should have 2 children", ^{
                [[person.children should] haveCountOf:2];
                [person.children enumerateObjectsUsingBlock:^(ManagedPerson* person, BOOL *stop) {
                    if ([person.name isEqualToString:@"Masha"]) {
                        [[person.relative.name should] equal:@"Alexey"];
                        [[person.children should] haveCountOf:0];

                    } else if ([person.name isEqualToString:@"Elena"]) {
                        [person.relative shouldBeNil];
                        [[person.children should] haveCountOf:0];

                    } else {
                        fail(@"unexpected person");
                    }
                }];
            });
            
        });
    });

    describe(@".arrayOfObjectsFromExternalRepresentation:withMapping:", ^{
        
        __block NSManagedObjectContext* moc;
        __block NSArray *carsArray;
        __block NSArray *externalRepresentation;
        
        beforeEach(^{
            moc = [NSManagedObjectContext MR_defaultContext];
            externalRepresentation = [CMFixture buildUsingFixture:@"Cars"];
            carsArray = [EKManagedObjectMapper arrayOfObjectsFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carMapping] inManagedObjectContext:moc];
        });
        
        specify(^{
            [carsArray shouldNotBeNil];
        });
        
        specify(^{
            [[carsArray should] haveCountOf:[externalRepresentation count]];
        });
        
    });
  
    describe(@".arrayOfObjectsFromExternalRepresentation:withMapping: inserted objects", ^{

    __block NSManagedObjectContext* moc;
    __block NSArray *externalRepresentation;
    __block NSArray *people = nil;

    beforeEach(^{
        moc = [NSManagedObjectContext MR_defaultContext];
        externalRepresentation = [CMFixture buildUsingFixture:@"PersonsWithSamePhones"];
        [ManagedPhone registerMapping:[ManagedMappingProvider phoneMapping]];
    });

    specify(^{
      people = [EKManagedObjectMapper arrayOfObjectsFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider personWithPhonesMapping] inManagedObjectContext:moc];
      
      ManagedPhone * phone = [[people.firstObject phones] anyObject];
      ManagedPhone * phone2 = [[people.lastObject phones] anyObject];
      
      [[phone should] equal:phone2];
    });

    });
    
    describe(@".syncArrayOfObjectsFromExternalRepresentation:withMapping:fetchRequest:", ^{
        
    });
    
    context(@"hasOneMapping with several non nested keys", ^{
        __block ManagedPerson * person = nil;
        
        beforeEach(^{
            NSDictionary * externalRepresentation = [CMFixture buildUsingFixture:@"PersonNonNested"];
            [ManagedPerson registerMapping:[ManagedMappingProvider personNonNestedMapping]];
            person = [EKManagedObjectMapper objectFromExternalRepresentation:externalRepresentation
                                                                 withMapping:[ManagedMappingProvider personNonNestedMapping]
                                                      inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
        });
        
        it(@"should contain car", ^{
            [[person.car should] beKindOfClass:[ManagedCar class]];
        });
        
        it(@"should have correct name", ^{
            [[person.name should] equal:@"Lucas"];
        });
        
        it(@"should have correct car properties", ^{
            [[person.car.carID should] equal:@3];
            [[person.car.model should] equal:@"i30"];
            [[person.car.year should] equal:@"2013"];
        });
    });
});

SPEC_END
