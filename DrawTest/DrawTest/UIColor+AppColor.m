//
//  UIColor+AppColor.m
//  ZiPeiYi
//
//  Created by FrankLiu on 16/2/3.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import "UIColor+AppColor.h"

#import "NSString+HexColors.h"

@implementation UIColor (AppColor)

+ (UIColor *)appBackgroundGrayColor {

    return [@"F4F4F4" hexColor];
}

+ (UIColor *)appSeparateGrayColor {

    return [@"E1E1E1" hexColor];
}

+ (UIColor *)appSeparateLightGrayColor {

    return [@"E7E7E7" hexColor];
}

+ (UIColor *)appTextOrangeColor {

    return [@"FF5A00" hexColor];
}

+ (UIColor *)appTextGreenColor {

    return [@"048E63" hexColor];
}

+ (UIColor *)appTextBlackColor {

    return [@"333333" hexColor];
}

+ (UIColor *)appExceptionRedColor {

    return [@"E30000" hexColor];
}

@end
