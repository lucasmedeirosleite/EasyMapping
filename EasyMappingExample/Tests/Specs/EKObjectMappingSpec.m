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
            [[mapping should] respondToSelector:@selector(mapKey:toField:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKey:toField:withDateFormat:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapFieldsFromArray:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapFieldsFromArrayToPascalCase:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapFieldsFromDictionary:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKey:toField:withValueBlock:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKey:toField:withValueBlock:withReverseBlock:)];
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
            [[mapping should] respondToSelector:@selector(mapFieldsFromMappingObject:)];
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
    
    describe(@"#mapKey:toField:", ^{
       
        __block EKObjectMapping *mapping;
        __block EKFieldMapping *fieldMapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapKey:@"created_at" toField:@"createdAt"];
            fieldMapping = [mapping.propertyMappings objectForKey:@"created_at"];
        });
        
        specify(^{
            [[fieldMapping.keyPath should] equal:@"created_at"];
        });
        
        specify(^{
            [[fieldMapping.field should] equal:@"createdAt"];
        });
        
    });
    
    describe(@"#mapKeyFieldsFromArray", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapFieldsFromArray:@[@"name", @"email"]];
        });
        
        describe(@"name field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.propertyMappings objectForKey:@"name"];
            });
            
            specify(^{
                [[fieldMapping shouldNot] beNil];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"name"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"name"];
            });
            
        });
        
        describe(@"email field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.propertyMappings objectForKey:@"email"];
            });
            
            specify(^{
                [[fieldMapping shouldNot] beNil];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"email"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"email"];
            });
            
        });
        
    });
    
    describe(@"#mapKeyFieldsFromArrayToPascalCase", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapFieldsFromArrayToPascalCase:@[@"name", @"email"]];
        });
        
        describe(@"name field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.propertyMappings objectForKey:@"Name"];
            });
            
            specify(^{
                [[fieldMapping shouldNot] beNil];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"Name"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"name"];
            });
        });
        
        describe(@"email field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.propertyMappings objectForKey:@"Email"];
            });
            
            specify(^{
                [[fieldMapping shouldNot] beNil];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"Email"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"email"];
            });
            
        });
        
    });
    
    
    describe(@"#mapKeyFieldsFromDictionary", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Car class]];
            [mapping mapFieldsFromDictionary:@{
                @"id" : @"identifier",
                @"contact.email" : @"email"
            }];
        });
        
        describe(@"identifier field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.propertyMappings objectForKey:@"id"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"id"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"identifier"];
            });
        });
        
        describe(@"email field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.propertyMappings objectForKey:@"contact.email"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"contact.email"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"email"];
            });
            
        });
        
    });

    describe(@"#mapFieldsFromMappingObject", ^{
        
        __block EKObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[ColoredUFO class]];
            [mapping mapFieldsFromMappingObject:[UFO objectMapping]];
        });
        
        
        specify(^{
            [mapping.propertyMappings shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.propertyMappings objectForKey:@"shape"] shouldNotBeNil];
        });
        
        specify(^{
            [[[[mapping.propertyMappings objectForKey:@"shape"] field] should] equal:@"shape"];
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
            [mapping mapKey:@"birthdate" toField:@"birthdate" withDateFormat:@"yyyy-MM-dd"];
            
        });
        
        specify(^{
            [[mapping.propertyMappings objectForKey:@"birthdate"] shouldNotBeNil];
        });
        
        specify(^{
            [[[mapping.propertyMappings objectForKey:@"birthdate"] should] beKindOfClass:[EKFieldMapping class]];
        });
    });
    
    describe(@"#mapKey:toField:withValueBlock:", ^{
        
        __block EKObjectMapping *mapping;
        __block EKFieldMapping *fieldMapping;
        
        beforeEach(^{
            
            NSDictionary *genders = @{
                                     @"male": @(GenderMale),
                                     @"female": @(GenderFemale)
                                     };
            
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
            [mapping mapKey:@"gender" toField:@"gender" withValueBlock:^id(NSString *key, id value) {
                return genders[key];
            }];
            
            fieldMapping = [mapping.propertyMappings objectForKey:@"gender"];
            
        });
        
        specify(^{
            [fieldMapping shouldNotBeNil];
        });
        
        specify(^{
            [fieldMapping.valueBlock shouldNotBeNil];
        });
        
    });

    
    describe(@"#mapKey:toField:withValueBlock:withReverseBlock:", ^{
       
        __block EKObjectMapping *mapping;
        __block EKFieldMapping *fieldMapping;
        
        beforeEach(^{
            
            NSDictionary *genders = @{
                                      @"male": @(GenderMale),
                                      @"female": @(GenderFemale)
                                      };
            
            mapping = [[EKObjectMapping alloc] initWithObjectClass:[Person class]];
            [mapping mapKey:@"gender" toField:@"gender" withValueBlock:^id(NSString *key, id value) {
                return genders[key];
            } withReverseBlock:^id(id value) {
                return [genders allKeysForObject:value].lastObject;
            }];
            
            fieldMapping = [mapping.propertyMappings objectForKey:@"gender"];
            
        });
        
        specify(^{
            [fieldMapping shouldNotBeNil];
        });
        
        specify(^{
            [fieldMapping.valueBlock shouldNotBeNil];
        });
        
        specify(^{
            [fieldMapping.valueBlock shouldNotBeNil];
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
    
});

SPEC_END


