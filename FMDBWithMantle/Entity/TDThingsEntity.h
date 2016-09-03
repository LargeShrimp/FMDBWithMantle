//
//  TDThingsEntity.h
//  FMDBWithMantle
//
//  Created by taitanxiami on 16/9/3.
//  Copyright © 2016年 taitanxiami. All rights reserved.
//

#import "BaseEntity.h"
#import <Foundation/Foundation.h>
#import <MTLFMDBAdapter.h>

@interface TDThingsEntity : BaseEntity<MTLFMDBSerializing>

@property (strong, nonatomic) NSNumber *thingsId;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *creatAt;
@property (strong, nonatomic) NSString *userName;


@end
