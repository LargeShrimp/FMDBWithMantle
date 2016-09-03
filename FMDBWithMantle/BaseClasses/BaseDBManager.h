//
//  BaseDBManager.h
//  FMDBWithMantle
//
//  Created by taitanxiami on 16/9/3.
//  Copyright © 2016年 taitanxiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import <Mantle.h>
#import <FMDBMigrationManager.h>
#import <FMDatabaseAdditions.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>
#define DefaultDatabaseFileName @"MainDataBase.sqlite"
@interface BaseDBManager : NSObject

@property (strong, nonatomic) FMDatabase *db;

+ (instancetype)shareInstance;

+ (void)insertOnDuplicateUpdate:(MTLModel<MTLFMDBSerializing> *)entity;

@end
