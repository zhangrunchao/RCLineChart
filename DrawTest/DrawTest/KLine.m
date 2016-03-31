//
//  KLine.m
//  DrawTest
//
//  Created by ZRC on 16/3/31.
//  Copyright © 2016年 zrc. All rights reserved.
//

#import "KLine.h"

@implementation KLine
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.startPoint = self.frame.origin;
        self.endPoint = self.frame.origin;
        self.color = @"#ff9933";
        self.lineWidth = 2.0f;
        self.isKLine= NO;
        self.isVol = NO;
    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    
    
    // 获取绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.isK) {
        // 画k线
        for (NSArray *item in self.points) {
            // 转换坐标
            CGPoint heightPoint,lowPoint,openPoint,closePoint;
            heightPoint = CGPointFromString([item objectAtIndex:0]);
            lowPoint = CGPointFromString([item objectAtIndex:1]);
            openPoint = CGPointFromString([item objectAtIndex:2]);
            closePoint = CGPointFromString([item objectAtIndex:3]);
            [self drawKWithContext:context height:heightPoint Low:lowPoint open:openPoint close:closePoint width:self.lineWidth];
        }
        
    }else{
        // 画连接线
        [self drawLineWithContext:context];
    }
    
    
    
    
}


@end
