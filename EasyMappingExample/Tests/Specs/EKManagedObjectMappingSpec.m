//
//  EKManagedObjectMappingSpec.m
//  EasyMappingCoreDataExample
//
//  Created by Alejandro Isaza on 2013-03-16.
//
//

#import "Kiwi.h"
#import "EasyMapping.h"
#import "ManagedPerson.h"
#import "ManagedCar.h"
#import "ManagedMappingProvider.h"
#import <CoreData/CoreData.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

SPEC_BEGIN(EKManagedObjectMappingSpec)

describe(@"EKManagedObjectMapping", ^{
    
    describe(@"class methods", ^{
        
        specify(^{
            [[EKManagedObjectMapping should] respondToSelector:@selector(mappingForEntityName:withBlock:)];
        });
        
        specify(^{
            [[EKManagedObjectMapping should] respondToSelector:@selector(mappingForEntityName:withRootPath:withBlock:)];
        });
        
    });
    
    describe(@"constructors", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] init];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithEntityName:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(initWithEntityName:withRootPath:)];
        });
        
    });
    
    describe(@"instance methods", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] init];
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
            [[mapping should] respondToSelector:@selector(hasMany:forKeyPath:)];
        });
        
    });
    
    describe(@"properties", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] init];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(entityName)];
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
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [EKManagedObjectMapping mappingForEntityName:@"Car" withBlock:^(EKManagedObjectMapping *mapping) {
                
            }];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.entityName should] equal:@"Car"];
        });
        
    });
    
    describe(@".mappingForClass:withRootPath:withBlock:", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [EKManagedObjectMapping mappingForEntityName:@"Car" withRootPath:@"car" withBlock:^(EKManagedObjectMapping *mapping) {
                
            }];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.entityName should] equal:@"Car"];
        });
        
        specify(^{
            [[mapping.rootPath should] equal:@"car"];
        });
        
    });
    
    describe(@"#initWithObjectClass:", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Car"];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.entityName should] equal:@"Car"];
        });
        
    });
    
    describe(@"#initWithObjectClass:withRootPath:", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Car" withRootPath:@"car"];
        });
        
        specify(^{
            [mapping shouldNotBeNil];
        });
        
        specify(^{
            [[mapping.entityName should] equal:@"Car"];
        });
        
        specify(^{
            [[mapping.rootPath should] equal:@"car"];
        });
        
    });
    
    describe(@"#mapKey:toProperty:", ^{
        
        __block EKManagedObjectMapping *mapping;
        __block EKPropertyMapping *propertyMapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Car"];
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
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Car"];
            [mapping mapPropertiesFromArray:@[@"name", @"email"]];
        });
        
        describe(@"name property", ^{
            
            __block EKPropertyMapping *propertyMapping;
            
            beforeEach(^{
                propertyMapping = [mapping.propertyMappings objectForKey:@"name"];
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
                [[propertyMapping.keyPath should] equal:@"email"];
            });
            
            specify(^{
                [[propertyMapping.property should] equal:@"email"];
            });
            
        });
        
    });
    
    describe(@"#mapPropertiesFromDictionary", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Car"];
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
    
    describe(@"#mapKeyPath:toProperty:withDateFormat", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Car"];
            [mapping mapKeyPath:@"birthdate" toProperty:@"birthdate" withDateFormatter:[NSDateFormatter ek_formatterForCurrentThread]];
            
        });
        
        specify(^{
            [[mapping.propertyMappings objectForKey:@"birthdate"] shouldNotBeNil];
        });
        
        specify(^{
            [[[mapping.propertyMappings objectForKey:@"birthdate"] should] beKindOfClass:[EKPropertyMapping class]];
        });
        
    });
    
    describe(@"#hasOneMapping:forKey:", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [ManagedMappingProvider personMapping];
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
    
    describe(@"#hasManyMapping:forKey:", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [ManagedMappingProvider personMapping];
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
