//
//  UIColor+AppColor.h
//  ZiPeiYi
//
//  Created by FrankLiu on 16/2/3.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AppColor)

/**
 *  TableView等的主体背景灰色 F4F4F4
 *
 *  @return F4F4F4
 */
+ (UIColor *)appBackgroundGrayColor;

/**
 *  Cell之间的分割线灰色 E1E1E1
 *
 *  @return E1E1E1
 */
+ (UIColor *)appSeparateGrayColor;

/**
 *  Cell内的分割线灰色 E7E7E7
 *
 *  @return E7E7E7
 */
+ (UIColor *)appSeparateLightGrayColor;

/**
 *  文本橙色,如股票上涨 FF5A00
 *
 *  @return FF5A00
 */
+ (UIColor *)appTextOrangeColor;

/**
 *  文本绿色 048E63
 *
 *  @return 048E63
 */
+ (UIColor *)appTextGreenColor;

/**
 *  文本黑色 333333
 *
 *  @return 333333
 */
+ (UIColor *)appTextBlackColor;

/**
 *  异常红色,如策略未能平仓 E30000
 *
 *  @return E30000
 */
+ (UIColor *)appExceptionRedColor;

@end
