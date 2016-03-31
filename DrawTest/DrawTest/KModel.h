//
//  KModel.h
//  DrawTest
//
//  Created by ZRC on 16/3/29.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KModel : NSObject

@property(nonatomic,strong) NSString *date;                 //日期
@property(nonatomic,strong) NSNumber *open;                 //开盘价
@property(nonatomic,strong) NSNumber *high;                 //最高价
@property(nonatomic,strong) NSNumber *low;                  //最低价
@property(nonatomic,strong) NSNumber *close;                //收盘价
@property(nonatomic,strong) NSNumber *salesVolume;          //成交量
@property(nonatomic,strong) NSNumber *ma5;                  //前五日收盘价均值
@property(nonatomic,strong) NSNumber *ma10;                 //前十日收盘价均值
@property(nonatomic,strong) NSNumber *ma20;                 //前二十日收盘价均值

@end
