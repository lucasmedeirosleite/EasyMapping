//
//  EKPropertyMappingSpec.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 22/02/13.
//  Copyright 2013 EasyKit. All rights reserved.
//

#import "EKPropertyMapping.h"

SPEC_BEGIN(EKPropertyMappingSpec)

describe(@"EKPropertyMapping", ^{
   
    __block EKPropertyMapping *mapping;
    
    beforeEach(^{
        mapping = [[EKPropertyMapping alloc] init];
    });
    
    specify(^{
        [[mapping should] respondToSelector:@selector(keyPath)];
    });
    
    specify(^{
        [[mapping should] respondToSelector:@selector(property)];
    });
    
    specify(^{
        [[mapping should] respondToSelector:@selector(valueBlock)];
    });
    
    specify(^{
        [[mapping should] respondToSelector:@selector(reverseBlock)];
    });
    
    specify(^{
        [[mapping should] respondToSelector:@selector(managedValueBlock)];
    });
    
    specify(^{
        [[mapping should] respondToSelector:@selector(managedReverseBlock)];
    });
    
});

SPEC_END


