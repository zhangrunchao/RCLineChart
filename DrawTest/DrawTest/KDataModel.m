//
//  KDataModel.m
//  DrawTest
//
//  Created by ZRC on 16/4/1.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import "KDataModel.h"

@implementation KDataModel

-(id)initWithData:(NSArray*)data kCount:(int)kCount{
    self = [super init];
    if (self) {
        self.kCount = kCount;
        self.dataArray = data;
        [self changeData];
    }
    
    return self;
}



-(void)changeData{
//    NSMutableArray *data =[[NSMutableArray alloc] init];
//    NSMutableArray *category =[[NSMutableArray alloc] init];
    NSArray *newArray = self.dataArray;
    newArray = [newArray objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:
                                           NSMakeRange(0, self.kCount>=newArray.count?newArray.count:self.kCount)]]; // 只要前面指定的数据
    //NSLog(@"lines:%@",newArray);
    NSInteger idx;
    int MA5=5,MA10=10,MA20=20; // 均线统计
    for (idx = newArray.count-1; idx > 0; idx--) {
        KModel *model = [newArray objectAtIndex:idx];
        if(!model){
            continue;
        }
       
        // 收盘价的最小值和最大值
        if ([model.high floatValue]>self.maxValue) {
            self.maxValue = [model.high floatValue];
        }
        if ([model.low floatValue]<self.minValue) {
            self.minValue = [model.low floatValue];
        }
        // 成交量的最大值最小值
        if ([model.salesVolume floatValue]>self.volMaxValue) {
            self.volMaxValue = [model.salesVolume floatValue];
        }
        if ([model.salesVolume floatValue]<self.volMinValue) {
            self.volMinValue = [model.salesVolume floatValue];
        }
//        NSMutableArray *item =[[NSMutableArray alloc] init];
//        [item addObject:model.open]; // open
//        [item addObject:model.high]; // high
//        [item addObject:model.low]; // low
//        [item addObject:model.close]; // close
//        [item addObject:model.salesVolume]; // volume 成交量
        CGFloat idxLocation = [self.dataArray indexOfObject:model];
        // MA5
        [model setMa5:[NSNumber numberWithFloat:[self sumArrayWithData:self.dataArray andRange:NSMakeRange(idxLocation, MA5)]]]; // 前五日收盘价平均值
        // MA10
        [model setMa10:[NSNumber numberWithFloat:[self sumArrayWithData:self.dataArray andRange:NSMakeRange(idxLocation, MA10)]]]; // 前十日收盘价平均值
        // MA20
        [model setMa20:[NSNumber numberWithFloat:[self sumArrayWithData:self.dataArray andRange:NSMakeRange(idxLocation, MA20)]]]; // 前二十日收盘价平均值
        // 前面二十个数据不要了，因为只是用来画均线的
//        [category addObject:model.date]; // date
//        [data addObject:item];
    }
//    if(data.count==0){
//        return;
//    }
    
    //NSLog(@"%@",data);
}


-(CGFloat)sumArrayWithData:(NSArray*)data andRange:(NSRange)range{
    CGFloat value = 0;
    if (data.count - range.location>range.length) {
        NSArray *newArray = [data objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:range]];
        for (KModel *item in newArray) {
            
            value += [item.close floatValue];
        }
        if (value>0) {
            value = value / newArray.count;
        }
    }
    return value;
}
@end
