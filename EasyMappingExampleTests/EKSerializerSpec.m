//
//  EKSerializerSpec.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 25/02/13.
//  Copyright 2013 EasyKit. All rights reserved.
//

#import "Kiwi.h"
#import "CMFactory.h"
#import "EasyMapping.h"
#import "MappingProvider.h"
#import "Person.h"
#import "Car.h"
#import "Phone.h"
#import "Address.h"
#import <CoreLocation/CoreLocation.h>

SPEC_BEGIN(EKSerializerSpec)

describe(@"EKSerializer", ^{
    
    describe(@"class methods", ^{
        
        specify(^{
            [[EKSerializer should] respondToSelector:@selector(serializeObject:withMapping:)];
        });
        
        specify(^{
            [[EKSerializer should] respondToSelector:@selector(serializeCollection:withMapping:)];
        });
        
    });
   
    describe(@".serializeObject:withMapping:", ^{
       
        context(@"a simple object", ^{
           
            __block Car *car;
            __block NSDictionary *representation;
            
            beforeEach(^{
               
                CMFactory *factory = [CMFactory forClass:[Car class]];
                [factory addToField:@"model" value:^{
                   return @"i30";
                }];
                [factory addToField:@"year" value:^{
                   return @"2013";
                }];
                car = [factory build];
                representation = [EKSerializer serializeObject:car withMapping:[MappingProvider carMapping]];
            });
            
            specify(^{
                [representation shouldNotBeNil];
            });
            
            specify(^{
                [[[representation objectForKey:@"model"] should]equal:[car.model description]];
            });
            
            specify(^{
                [[[representation objectForKey:@"year"] should] equal:[car.year description]];
            });
            
        });
        
        context(@"with reverse block", ^{
           
            context(@"when male", ^{
                
                __block Person *person;
                __block NSDictionary *representation;
                
                beforeEach(^{
                    
                    CMFactory *factory = [CMFactory forClass:[Person class]];
                    [factory addToField:@"name" value:^{
                        return @"Lucas";
                    }];
                    [factory addToField:@"email" value:^{
                        return @"lucastoc@gmail.com";
                    }];
                    [factory addToField:@"gender" value:^{
                        return @(GenderMale);
                    }];
                    person = [factory build];
                    representation = [EKSerializer serializeObject:person withMapping:[MappingProvider personWithOnlyValueBlockMapping]];
                    
                });
                
                specify(^{
                    [representation shouldNotBeNil];
                });
                
                specify(^{
                    [[[representation objectForKey:@"gender"] should] equal:@"male"];
                });

            });
            
            context(@"when female", ^{
                
                __block Person *person;
                __block NSDictionary *representation;
                
                beforeEach(^{
                    
                    CMFactory *factory = [CMFactory forClass:[Person class]];
                    [factory addToField:@"name" value:^{
                        return @"A woman";
                    }];
                    [factory addToField:@"email" value:^{
                        return @"woman@gmail.com";
                    }];
                    [factory addToField:@"gender" value:^{
                        return @(GenderFemale);
                    }];
                    person = [factory build];
                    representation = [EKSerializer serializeObject:person withMapping:[MappingProvider personWithOnlyValueBlockMapping]];
                    
                });
                
                specify(^{
                    [[[representation objectForKey:@"gender"] should] equal:@"female"];
                });
                
            });
            
            context(@"reverse block with custom object", ^{
                
                __block Address *address;
                __block NSDictionary *representation;
                
                beforeEach(^{
                   
                    CMFactory *factory = [CMFactory forClass:[Address class]];
                    [factory addToField:@"street" value:^{
                        return @"A street";
                    }];
                    [factory addToField:@"location" value:^{
                        return [[CLLocation alloc] initWithLatitude:-30.12345 longitude:-3.12345];
                    }];
                    address = [factory build];
                    representation = [EKSerializer serializeObject:address withMapping:[MappingProvider addressMapping]];
                    
                });
                
                specify(^{
                    [representation shouldNotBeNil];
                });
                
                specify(^{
                    [[representation objectForKey:@"location"] shouldNotBeNil];
                });
                
                specify(^{
                    [[[representation objectForKey:@"location"] should] beKindOfClass:[NSArray class]];
                });
                
            });
            
            context(@"with hasOneRelation", ^{
               
                __block Person *person;
                __block NSDictionary *representation;
               
                beforeEach(^{
                    
                    CMFactory *factory = [CMFactory forClass:[Person class]];
                    [factory addToField:@"name" value:^{
                        return @"Lucas";
                    }];
                    [factory addToField:@"email" value:^{
                        return @"lucastoc@gmail.com";
                    }];
                    [factory addToField:@"car" value:^{
                        Car *car = [[Car alloc] init];
                        car.model = @"HB20";
                        car.year = @"2012";
                        return car;
                    }];
                    person = [factory build];
                    representation = [EKSerializer serializeObject:person withMapping:[MappingProvider personWithCarMapping]];
                    
                });
                
                specify(^{
                    [representation shouldNotBeNil];
                });
                
                specify(^{
                    [[[representation objectForKey:@"car"] should] beKindOfClass:[NSDictionary class]];
                });
                
            });
            
            context(@"with hasManyRelation", ^{
                
                __block Person *person;
                __block NSDictionary *representation;
                
                beforeEach(^{
                    
                    CMFactory *factory = [CMFactory forClass:[Person class]];
                    [factory addToField:@"name" value:^{
                        return @"Lucas";
                    }];
                    [factory addToField:@"email" value:^{
                        return @"lucastoc@gmail.com";
                    }];
                    [factory addToField:@"phones" value:^{
                        Phone *phone1 = [[Phone alloc] init];
                        phone1.DDI = @"55";
                        phone1.DDD = @"85";
                        phone1.number = @"1111-1111";
                        Phone *phone2 = [[Phone alloc] init];
                        phone2.DDI = @"55";
                        phone2.DDD = @"11";
                        phone2.number = @"2222-2222";
                        return @[phone1, phone2];
                    }];
                    person = [factory build];
                    representation = [EKSerializer serializeObject:person withMapping:[MappingProvider personWithPhonesMapping]];
                    
                });
                
                specify(^{
                    [representation shouldNotBeNil];
                });
                
                specify(^{
                    NSLog(@"Person representation: %@", representation);
                    [[[representation objectForKey:@"phones"] should] beKindOfClass:[NSArray class]];
                });
                
            });
                        
        });
        
    });
    
});

SPEC_END


