//
//  EKMappingTimestampFormats.h
//  EasyMappingExample
//
//  Created by Sergii Kryvoblotskyi on 1/15/15.
//  Copyright (c) 2015 EasyKit. All rights reserved.
//

typedef NS_ENUM(NSInteger, EKTimestampFormat){
    /**
     *  Represents "seconds" format. Like 1421333849 for 01/15/2015 16:57:29
     */
    EKTimestampFormatSeconds,
    /**
     *  Represents "milliseconds" format. Like 1421333849000 for 01/15/2015 16:57:29
     */
    EKTimestampFormatMilliseconds
};