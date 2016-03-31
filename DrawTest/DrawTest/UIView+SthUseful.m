//
//  UIView+SthUseful.m
//  ZiPeiYi
//
//  Created by YouXianMing on 15/12/23.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import "UIView+SthUseful.h"

@implementation UIView (SthUseful)

+ (UIView *)lineViewWithFrame:(CGRect)frame color:(UIColor *)color {
    
    UIView *line         = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    
    return line;
}

@end
