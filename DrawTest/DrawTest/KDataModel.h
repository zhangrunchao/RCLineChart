//
//  KDataModel.h
//  DrawTest
//
//  Created by ZRC on 16/4/1.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KModel.h"
typedef enum : NSUInteger {
    MA5 = 0x01,
    MA10,
    MA20
} MAType;
@interface KDataModel : NSObject
@property (nonatomic,strong) NSArray  *dataArray;
@property (nonatomic       ) CGFloat  maxValue;
@property (nonatomic       ) CGFloat  minValue;
@property (nonatomic       ) CGFloat  volMaxValue;
@property (nonatomic       ) CGFloat  volMinValue;
@property (nonatomic,assign) int kCount; // k线中实体的总数 通过 xWidth / kLineWidth 计算而来

-(id)initWithData:(NSArray*)data kCount:(int)kCount;


@end
