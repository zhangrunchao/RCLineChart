//
//  UIView+SthUseful.h
//  ZiPeiYi
//
//  Created by YouXianMing on 15/12/23.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SthUseful)

/**
 *  Create Line view.
 *
 *  @param frame Frame
 *  @param color Color
 *
 *  @return Line View.
 */
+ (UIView *)lineViewWithFrame:(CGRect)frame color:(UIColor *)color;

@end
