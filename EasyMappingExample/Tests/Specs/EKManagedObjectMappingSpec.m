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
            [[mapping should] respondToSelector:@selector(mapKey:toField:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapKey:toField:withDateFormat:)];
        });
        
        specify(^{
            [[mapping should] respondToSelector:@selector(mapFieldsFromArray:)];
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
            [[mapping should] respondToSelector:@selector(fieldMappings)];
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
    
    describe(@"#mapKey:toField:", ^{
        
        __block EKManagedObjectMapping *mapping;
        __block EKFieldMapping *fieldMapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Car"];
            [mapping mapKey:@"created_at" toField:@"createdAt"];
            fieldMapping = [mapping.fieldMappings objectForKey:@"created_at"];
        });
        
        specify(^{
            [[fieldMapping.keyPath should] equal:@"created_at"];
        });
        
        specify(^{
            [[fieldMapping.field should] equal:@"createdAt"];
        });
        
    });
    
    describe(@"#mapKeyFieldsFromArray", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Car"];
            [mapping mapFieldsFromArray:@[@"name", @"email"]];
        });
        
        describe(@"name field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.fieldMappings objectForKey:@"name"];
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
                fieldMapping = [mapping.fieldMappings objectForKey:@"email"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"email"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"email"];
            });
            
        });
        
    });
    
    describe(@"#mapKeyFieldsFromDictionary", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Car"];
            [mapping mapFieldsFromDictionary:@{
             @"id" : @"identifier",
             @"contact.email" : @"email"
             }];
        });
        
        describe(@"identifier field", ^{
            
            __block EKFieldMapping *fieldMapping;
            
            beforeEach(^{
                fieldMapping = [mapping.fieldMappings objectForKey:@"id"];
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
                fieldMapping = [mapping.fieldMappings objectForKey:@"contact.email"];
            });
            
            specify(^{
                [[fieldMapping.keyPath should] equal:@"contact.email"];
            });
            
            specify(^{
                [[fieldMapping.field should] equal:@"email"];
            });
            
        });
        
    });
    
    describe(@"#mapKey:toField:withDateFormat", ^{
        
        __block EKManagedObjectMapping *mapping;
        
        beforeEach(^{
            mapping = [[EKManagedObjectMapping alloc] initWithEntityName:@"Car"];
            [mapping mapKey:@"birthdate" toField:@"birthdate" withDateFormat:@"yyyy-MM-dd"];
            
        });
        
        specify(^{
            [[mapping.fieldMappings objectForKey:@"birthdate"] shouldNotBeNil];
        });
        
        specify(^{
            [[[mapping.fieldMappings objectForKey:@"birthdate"] should] beKindOfClass:[EKFieldMapping class]];
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
