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
#import <MagicalRecord/CoreData+MagicalRecord.h>

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
            [[EKMapper should] respondToSelector:@selector(objectFromExternalRepresentation:withMapping:inManagedObjectContext:)];
        });
        
        specify(^{
            [[EKMapper should] respondToSelector:@selector(arrayOfObjectsFromExternalRepresentation:withMapping:inManagedObjectContext:)];
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
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carMapping] inManagedObjectContext:moc];
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
                
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carMapping] inManagedObjectContext:moc];
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
                
                externalRepresentation = @{ @"id": @(1), @"model": @"i30", };
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carMapping] inManagedObjectContext:moc];
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
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carWithRootKeyMapping] inManagedObjectContext:moc];
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
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carNestedAttributesMapping] inManagedObjectContext:moc];
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
                car = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carWithDateMapping] inManagedObjectContext:moc];
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
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider personMapping] inManagedObjectContext:moc];
                
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
                person = [EKMapper objectFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider personMapping] inManagedObjectContext:moc];
            });
            
            specify(^{
                [person.phones shouldNotBeNil];
            });
            
            specify(^{
                [[person.phones should] haveCountOf:2];
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
            carsArray = [EKMapper arrayOfObjectsFromExternalRepresentation:externalRepresentation withMapping:[ManagedMappingProvider carMapping] inManagedObjectContext:moc];
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
