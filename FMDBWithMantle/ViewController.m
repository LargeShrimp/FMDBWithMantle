//
//  ViewController.m
//  FMDBWithMantle
//
//  Created by taitanxiami on 16/9/3.
//  Copyright © 2016年 taitanxiami. All rights reserved.
//

#import "ViewController.h"
#import "TDDBManager.h"
#import "TDThingsEntity.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    //insert
    NSDictionary *things = @{@"content":@"I am a spider man !",@"creatAt":@"2016-45-12",@"id":@4,@"userName":@"taitanxiamis"};
    TDThingsEntity * entity =     [TDThingsEntity entityFromDictionary:things];
    [TDDBManager insertOnDuplicateUpdate:entity];
    
    
    //query count
    NSNumber *count = [TDDBManager getDataCount:[TDThingsEntity class]];
    NSLog(@"count = %@",count);
    
    
    //query with key and value
   NSArray *models =  [TDDBManager findByColumn:@"content" columnValue:@"I am a spider man !" withClass:[TDThingsEntity class]];

    //delete with model main key
    BOOL success = [TDDBManager deleteUsingPrimaryKeys:models.firstObject];
    if (success) {
        NSLog(@"删除成功");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
