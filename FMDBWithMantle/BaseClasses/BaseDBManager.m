//
//  BaseDBManager.m
//  FMDBWithMantle
//
//  Created by taitanxiami on 16/9/3.
//  Copyright © 2016年 taitanxiami. All rights reserved.
//

#import "BaseDBManager.h"

@implementation BaseDBManager

+ (instancetype)shareInstance {
    
    static BaseDBManager *_shareDBManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareDBManager = [[BaseDBManager alloc]init];
    });
    return _shareDBManager;
}

- (instancetype)init {
    
    self = [super init ];
    if (self) {
        
        BOOL reuslt = [self repareDatabase:nil];
        if(reuslt) {
            NSLog(@"Database initialization successfully!");
        }else {
            NSLog(@"Database initialization failed!");
        }
    }
    return self;
}

- (BOOL)repareDatabase:(NSError * __autoreleasing *)error {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths.firstObject;
    //拼接路径
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:DefaultDatabaseFileName];
    
    self.db = [FMDatabase databaseWithPath:filePath];
    
    [self.db open];
    
//    // Get migration path
//    NSBundle *parentBundle = [NSBundle bundleForClass:[BaseDBManager class]];
////    NSBundle *migrationBundle = [NSBundle bundleWithPath:[parentBundle pathForResource:@"Migrations" ofType:@"bundle"]];
//    NSBundle *migrationBundle = [NSBundle bundleWithPath:<#(nonnull NSString *)#>]
//    // Create schema_migrations Table, prepare for migrate the database
//    FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabase:self.db migrationsBundle:migrationBundle];
//    if (! [manager hasMigrationsTable]) {
//        if (! [manager createMigrationsTable:error]) {
//            return NO;
//        }
//    }
//    
//    // Migrate the database if needed
//    if ([manager needsMigration]) {
//        if (! [manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:error]) {
//            return NO;
//        }
//    }
    
    FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabaseAtPath:filePath  migrationsBundle:[NSBundle mainBundle]];
    BOOL resultState = NO;
    //创建迁移表
    if (!manager.hasMigrationsTable) {
        resultState = [manager createMigrationsTable:error];
        if (!resultState) {
            return  NO;
        }
    }
    //把数据库迁移到最大版本
    resultState = [manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:error];    
    if (!resultState) {
        return NO;
    }
    NSLog(@"Has `schema_migrations` table?: %@", manager.hasMigrationsTable ? @"YES" : @"NO");
    NSLog(@"Origin Version: %llu", manager.originVersion);
    NSLog(@"Current version: %llu", manager.currentVersion);
    NSLog(@"All migrations: %@", manager.migrations);
    NSLog(@"Applied versions: %@", manager.appliedVersions);
    NSLog(@"Pending versions: %@", manager.pendingVersions);
    return YES;
}


#pragma mark - Public Functions

+ (NSArray *)columnValuesForUpdate:(MTLModel<MTLFMDBSerializing> *)model {
    
    NSArray *columnValues = [MTLFMDBAdapter columnValues:model];
    NSArray *keysValues = [MTLFMDBAdapter primaryKeysValues:model];
    
    NSMutableArray *params = [NSMutableArray array];
    [params addObjectsFromArray:columnValues];
    [params addObjectsFromArray:keysValues];
    
    return params;
}

+ (BOOL)isExists:(MTLModel<MTLFMDBSerializing> *)model {
    if (!model) return NO;
    
    BOOL isExists = NO;
    NSString * query = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@ WHERE %@", [model.class FMDBTableName],  [MTLFMDBAdapter whereStatementForModel:model]];
    NSArray *params = [MTLFMDBAdapter primaryKeysValues:model];
    FMResultSet *resultSet = [[BaseDBManager shareInstance].db executeQuery:query withArgumentsInArray:params];
    if  ([resultSet next]) {
        NSNumber *count = [resultSet objectForColumnName:@"count"];
        NSLog(@"Count ---> %@", count);
        isExists = ([count intValue] > 0) ? YES : NO;
    }
    
    return isExists;
}

+ (void)insertOnDuplicateUpdate:(MTLModel<MTLFMDBSerializing> *)entity {
    if (!entity) return;
    
    if ([self.class isExists:entity])
    {
        NSString *stmt = [MTLFMDBAdapter updateStatementForModel:entity];
        NSArray *params = [self.class columnValuesForUpdate:entity];
        [[BaseDBManager shareInstance].db executeUpdate:stmt withArgumentsInArray:params];
    }
    else
    {
        NSString *stmt = [MTLFMDBAdapter insertStatementForModel:entity];
        NSArray *params = [MTLFMDBAdapter columnValues:entity];
        
        [[BaseDBManager shareInstance].db executeUpdate:stmt withArgumentsInArray:params];
    }
}

- (void)dealloc {
    [self.db close];
}
@end
