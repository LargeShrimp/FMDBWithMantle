//
//  TDThingsEntity.m
//  FMDBWithMantle
//
//  Created by taitanxiami on 16/9/3.
//  Copyright © 2016年 taitanxiami. All rights reserved.
//

#import "TDThingsEntity.h"

@implementation TDThingsEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"content":@"content",
             @"creatAt":@"creatAt",
             @"thingsId":@"id",
             @"userName":@"userName"
             };
    
}
+ (NSArray *)FMDBPrimaryKeys {
    return @[@"id"];
}

+ (NSString *)FMDBTableName {
    return @"tdThings";
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    
    return @{
             @"content":@"content",
             @"creatAt":@"creatAt",
             @"thingsId":@"id",
             @"userName":@"userName"
             };
}
@end
