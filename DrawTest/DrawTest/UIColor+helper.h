//
//  UIColor+helper.h
//  Kline
//
//  Created by zhangrunchao on 14-2-9.
//  Copyright (c) 2014年 zhangrunchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KColor;
@interface UIColor (helper)

+ (UIColor *) colorWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;
+ (KColor *) RGBWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;

@end
