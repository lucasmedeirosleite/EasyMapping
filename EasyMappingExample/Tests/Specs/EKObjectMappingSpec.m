//
//  EKObjectMappingSpec.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 22/02/13.
//  Copyright 2013 EasyKit. All rights reserved.
//

#import "Kiwi.h"
#import "EasyMapping.h"
#import "Person.h"
#import "Car.h"
#import "UFO.h"
#import "MappingProvider.h"
#import "EKRelationshipMapping.h"
#import "Phone.h"

SPEC_BEGIN(EKObjectMappingSpec)

describe(@"EKObjectMapping", ^{
 
    describe(@"#mapKey:toField:withDateFormat", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapKeyPath:@"birthdate" toProperty:@"birthdate" withDateFormatter:[NSDateFormatter new]];
            
        });
        
        specify(^{
            [[mapping.propertyMappings objectForKey:@"birthdate"] shouldNotBeNil];
        });
        
        specify(^{
            [[[mapping.propertyMappings objectForKey:@"birthdate"] should] beKindOfClass:[EKPropertyMapping class]];
        });
    });
    
    describe(@"#mapKey:toField:withValueBlock:", ^{
        
        __block EKObjectMapping *mapping;
        __block EKPropertyMapping *propertyMapping;
        
        beforeEach(^{
            
            NSDictionary *genders = @{
                                     @"male": @(GenderMale),
                                     @"female": @(GenderFemale)
                                     };
            
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
            [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^id(NSString *key, id value) {
                return genders[key];
            }];
            
            propertyMapping = [mapping.propertyMappings objectForKey:@"gender"];
            
        });
        
        specify(^{
            [propertyMapping shouldNotBeNil];
        });
        
        specify(^{
            [propertyMapping.valueBlock shouldNotBeNil];
        });
        
    });

    
    describe(@"#mapKey:toField:withValueBlock:withReverseBlock:", ^{
       
        __block EKObjectMapping *mapping;
        __block EKPropertyMapping *propertyMapping;
        
        beforeEach(^{
            
            NSDictionary *genders = @{
                                      @"male": @(GenderMale),
                                      @"female": @(GenderFemale)
                                      };
            
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
            [mapping mapKeyPath:@"gender" toProperty:@"gender" withValueBlock:^id(NSString *key, id value) {
                return genders[key];
            } reverseBlock:^id(id value) {
                return [genders allKeysForObject:value].lastObject;
            }];
            
            propertyMapping = [mapping.propertyMappings objectForKey:@"gender"];
            
        });
        
        specify(^{
            [propertyMapping shouldNotBeNil];
        });
        
        specify(^{
            [propertyMapping.valueBlock shouldNotBeNil];
        });
        
        specify(^{
            [propertyMapping.valueBlock shouldNotBeNil];
        });
        
    });
    
    describe(@"#hasOneMapping:forKey:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [MappingProvider personMapping];
        });
        
        specify(^{
            [[mapping hasOneMappings] shouldNotBeNil];
        });
        
        specify(^{
            [[@([mapping.hasOneMappings count]) should] equal:@1];
            [[[mapping.hasOneMappings.firstObject keyPath] should] equal:@"car"];
        });
        
        specify(^{
            [mapping.hasManyMappings shouldNotBeNil];
        });
        
        specify(^{
            [[[mapping.hasManyMappings.firstObject keyPath] should] equal:@"phones"];
        });
        
    });
    
    describe(@"#hasOneMapping:forKey:forField:", ^{
        __block EKObjectMapping * mapping;
       
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
            [Car registerMapping:[MappingProvider carMapping]];
            [Phone registerMapping:[MappingProvider phoneMapping]];
            [mapping hasOne:[Car class] forKeyPath:@"car" forProperty:@"personCar"];
            [mapping hasMany:[Phone class] forKeyPath:@"phones" forProperty:@"personPhones"];
        });
    });
    
    describe(@"#hasManyMapping:forKey:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [MappingProvider personMapping];
        });
        
        specify(^{
            [mapping.hasManyMappings shouldNotBeNil];
        });
        
        specify(^{
            [[[mapping.hasManyMappings.firstObject keyPath] should] equal:@"phones"];
        });
        
    });
    
    describe(@"#hasOne:forKeyPath:forProperty:withObjectMapping:", ^{
        __block EKObjectMapping * mapping;
        __block EKObjectMapping * phoneMapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
            phoneMapping = [Phone objectMapping];
            // Use different class on purpose, checking object mapping of the relationship
            [mapping hasOne:[Car class]
                 forKeyPath:@"phone"
                forProperty:@"phone"
          withObjectMapping:phoneMapping];
       });
        
        specify(^{
            [mapping.hasOneMappings shouldNotBeNil];
        });
        
        specify(^{
            [[[mapping.hasOneMappings.firstObject keyPath] should] equal:@"phone"];
        });
        
        specify(^{
            EKRelationshipMapping * relationship = [mapping.hasOneMappings firstObject];
            
            [[[relationship mappingForObject:relationship] should] equal:phoneMapping];
        });
    });
    
    describe(@"#hasMany:forKeyPath:forProperty:withObjectMapping:", ^{
        __block EKObjectMapping * mapping;
        __block EKObjectMapping * phoneMapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
            phoneMapping = [Phone objectMapping];
            // Use different class on purpose, checking object mapping of the relationship
            [mapping hasMany:[Car class]
                  forKeyPath:@"phone"
                 forProperty:@"phone"
           withObjectMapping:phoneMapping];
        });
        
        specify(^{
            [mapping.hasManyMappings shouldNotBeNil];
        });
        
        specify(^{
            [[[mapping.hasManyMappings.firstObject keyPath] should] equal:@"phone"];
        });
        
        specify(^{
            EKRelationshipMapping * relationship = [mapping.hasManyMappings firstObject];
            
            [[[relationship mappingForObject:relationship] should] equal:phoneMapping];
        });
    });
    
});

SPEC_END


