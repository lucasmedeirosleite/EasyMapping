//
//  EKFieldMappingSpec.m
//  EasyMappingExample
//
//  Created by Lucas Medeiros on 22/02/13.
//  Copyright 2013 EasyKit. All rights reserved.
//

#import "EKPropertyMapping.h"

SPEC_BEGIN(EKFieldMappingSpec)

describe(@"EKFieldMapping", ^{
   
    __block EKPropertyMapping *fieldMapping;
    
    beforeEach(^{
        fieldMapping = [[EKPropertyMapping alloc] init];
    });
    
    specify(^{
        [[fieldMapping should] respondToSelector:@selector(keyPath)];
    });
    
    specify(^{
        [[fieldMapping should] respondToSelector:@selector(property)];
    });
    
    specify(^{
        [[fieldMapping should] respondToSelector:@selector(valueBlock)];
    });
    
    specify(^{
        [[fieldMapping should] respondToSelector:@selector(reverseBlock)];
    });
    
});

SPEC_END


