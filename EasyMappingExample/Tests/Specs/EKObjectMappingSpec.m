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
#import "ColoredUFO.h"
#import "MappingProvider.h"
#import "EKRelationshipMapping.h"
#import "Phone.h"

SPEC_BEGIN(EKObjectMappingSpec)

describe(@"EKObjectMapping", ^{
   
    describe(@"class methods", ^{
        
        specify(^{
            [[EKObjectMapping should] respondToSelector:@selector(mappingForClass:withBlock:)];
        });
        
        specify(^{
            [[EKObjectMapping should] respondToSelector:@selector(mappingForClass:withRootPath:withBlock:)];
        });
        
    });
    
    describe(@"constructors", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] init];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithObjectClass:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithObjectClass:withRootPath:)];
        });
        
    });
    
    describe(@"instance methods", ^{
       
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] init];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKeyPath:toProperty:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKeyPath:toProperty:withDateFormat:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapPropertiesFromArray:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapPropertiesFromArrayToPascalCase:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapPropertiesFromDictionary:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKeyPath:toProperty:withValueBlock:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKeyPath:toProperty:withValueBlock:reverseBlock:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasOne:forKeyPath:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasOne:forKeyPath:forProperty:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasMany:forKeyPath:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasMany:forKeyPath:forProperty:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasOne:forKeyPath:forProperty:withObjectMapping:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasMany:forKeyPath:forProperty:withObjectMapping:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapPropertiesFromMappingObject:)];
        });
        
    });
    
    describe(@"properties", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] init];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(objectClass)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(setObjectClass:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(rootPath)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(propertyMappings)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasOneMappings)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(hasManyMappings)];
        });
        
    });
    
    describe(@".mappingForClass:withBlock:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
           mapping = [EKObjectMapping mappingForClass:[Car class] withBlock:^(EKObjectMapping *mapping) {
               
           }];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.objectClass should] equal:[Car class]];
        });
        
    });
    
    describe(@".mappingForClass:withRootPath:withBlock:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [EKObjectMapping mappingForClass:[Car class] withRootPath:@"car" withBlock:^(EKObjectMapping *mapping) {
                
            }];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.objectClass should] equal:[Car class]];
        });
        
        specify(^{
            [[mapping.rootPath should] equal:@"car"];
        });
        
    });
        
    describe(@"#initWithObjectClass:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.objectClass should] equal:[Car class]];
        });
        
    });
    
    describe(@"#initWithObjectClass:withRootPath:", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class] withRootPath:@"car"];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.objectClass should] equal:[Car class]];
        });
        
        specify(^{
            [[mapping.rootPath should] equal:@"car"];
        });
        
    });
    
    describe(@"#mapKeyPath:toProperty:", ^{
       
        __block EKObjectMapping *mapping;
        __block EKPropertyMapping *propertyMapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapKeyPath:@"created_at" toProperty:@"createdAt"];
            propertyMapping = [mapping.propertyMappings objectForKey:@"created_at"];
        });
        
        specify(^{
            [[propertyMapping.keyPath should] equal:@"created_at"];
        });
        
        specify(^{
            [[propertyMapping.property should] equal:@"createdAt"];
        });
        
    });
    
    describe(@"#mapPropertiesFromArray", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        });
        
        describe(@"name field", ^{
            
            __block EKPropertyMapping *propertyMapping;
            
            beforeEach(^{
                propertyMapping = [mapping.propertyMappings objectForKey:@"name"];
            });
            
            specify(^{
                [[propertyMapping shouldNot] beNil];
            });
            
            specify(^{
                [[propertyMapping.keyPath should] equal:@"name"];
            });
            
            specify(^{
                [[propertyMapping.property should] equal:@"name"];
            });
            
        });
        
        describe(@"email field", ^{
            
            __block EKPropertyMapping *propertyMapping;
            
            beforeEach(^{
                propertyMapping = [mapping.propertyMappings objectForKey:@"email"];
            });
            
            specify(^{
                [[propertyMapping shouldNot] beNil];
            });
            
            specify(^{
                [[propertyMapping.keyPath should] equal:@"email"];
            });
            
            specify(^{
                [[propertyMapping.property should] equal:@"email"];
            });
            
        });
        
    });
    
    describe(@"#mapKeyFieldsFromArrayToPascalCase", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapPropertiesFromArrayToPascalCase:@[@"name", @"email"]];
        });
        
        describe(@"name field", ^{
            
            __block EKPropertyMapping *propertyMapping;
            
            beforeEach(^{
                propertyMapping = [mapping.propertyMappings objectForKey:@"Name"];
            });
            
            specify(^{
                [[propertyMapping shouldNot] beNil];
            });
            
            specify(^{
                [[propertyMapping.keyPath should] equal:@"Name"];
            });
            
            specify(^{
                [[propertyMapping.property should] equal:@"name"];
            });
        });
        
        describe(@"email field", ^{
            
            __block EKPropertyMapping *propertyMapping;
            
            beforeEach(^{
                propertyMapping = [mapping.propertyMappings objectForKey:@"Email"];
            });
            
            specify(^{
                [[propertyMapping shouldNot] beNil];
            });
            
            specify(^{
                [[propertyMapping.keyPath should] equal:@"Email"];
            });
            
            specify(^{
                [[propertyMapping.property should] equal:@"email"];
            });
            
        });
        
    });
    
    
    describe(@"#mapPropertiesFromDictionary", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapPropertiesFromDictionary:@{
                @"id" : @"identifier",
                @"contact.email" : @"email"
            }];
        });
        
        describe(@"identifier field", ^{
            
            __block EKPropertyMapping *propertyMapping;
            
            beforeEach(^{
                propertyMapping = [mapping.propertyMappings objectForKey:@"id"];
            });
            
            specify(^{
                [[propertyMapping.keyPath should] equal:@"id"];
            });
            
            specify(^{
                [[propertyMapping.property should] equal:@"identifier"];
            });
        });
        
        describe(@"email field", ^{
            
            __block EKPropertyMapping *propertyMapping;
            
            beforeEach(^{
                propertyMapping = [mapping.propertyMappings objectForKey:@"contact.email"];
            });
            
            specify(^{
                [[propertyMapping.keyPath should] equal:@"contact.email"];
            });
            
            specify(^{
                [[propertyMapping.property should] equal:@"email"];
            });
            
        });
        
    });

    describe(@"#mapPropertiesFromMappingObject", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[ColoredUFO class]];
            [mapping mapPropertiesFromMappingObject:[UFO objectMapping]];
        });
        
        
        specify(^{
            [mapping.propertyMappings shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.propertyMappings objectForKey:@"shape"] shouldNotBeNil];
        });
        
        specify(^{
            [[[[mapping.propertyMappings objectForKey:@"shape"] property] should] equal:@"shape"];
        });
        
        
        specify(^{
            [[mapping hasOneMappings] shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.hasOneMappings objectForKey:@"captain"] shouldNotBeNil];
        });
        
        specify(^{
            [mapping.hasManyMappings shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.hasManyMappings objectForKey:@"crew"] shouldNotBeNil];
        });
        
    });
    
 
    describe(@"#mapKey:toField:withDateFormat", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapKeyPath:@"birthdate" toProperty:@"birthdate" withDateFormat:@"yyyy-MM-dd"];
            
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
            [[mapping.hasOneMappings objectForKey:@"car"] shouldNotBeNil];
        });
        
        specify(^{
            [mapping.hasManyMappings shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.hasManyMappings objectForKey:@"phones"] shouldNotBeNil];
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
            [[mapping.hasManyMappings objectForKey:@"phones"] shouldNotBeNil];
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
            [[mapping.hasOneMappings objectForKey:@"phone"] shouldNotBeNil];
        });
        
        specify(^{
            EKRelationshipMapping * relationship = [mapping.hasOneMappings objectForKey:@"phone"];
            
            [[[relationship objectMapping] should] equal:phoneMapping];
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
            [[mapping.hasManyMappings objectForKey:@"phone"] shouldNotBeNil];
        });
        
        specify(^{
            EKRelationshipMapping * relationship = [mapping.hasManyMappings objectForKey:@"phone"];
            
            [[[relationship objectMapping] should] equal:phoneMapping];
        });
    });
    
});

SPEC_END


