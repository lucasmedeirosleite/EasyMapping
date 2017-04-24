//
//  EKCoreDataImporter_EKCoreDataImporter.h
//  EasyMappingExample
//
//  Created by Денис Тележкин on 24.04.17.
//  Copyright © 2017 EasyKit. All rights reserved.
//

#import <EasyMapping/EasyMapping.h>

@interface EKCoreDataImporter()
@property (nonatomic, strong) NSSet * entityNames;
@property (nonatomic, strong) NSMutableDictionary * existingEntitiesPrimaryKeys;
@end
