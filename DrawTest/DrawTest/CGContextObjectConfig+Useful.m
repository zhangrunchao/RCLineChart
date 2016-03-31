//
//  CGContextObjectConfig+Useful.m
//  ZiPeiYi
//
//  Created by YouXianMing on 15/12/22.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import "CGContextObjectConfig+Useful.h"
#import "NSString+HexColors.h"

@implementation CGContextObjectConfig (Useful)

+ (CGContextObjectConfig *)color_3F5380 {

    CGContextObjectConfig *config = [CGContextObjectConfig new];
    config.phase                  = 0;
    config.count                  = 2;
    config.strokeColor            = [RGBColor colorWithUIColor:[@"#3F5380" hexColor]];
    config.fillColor              = [RGBColor colorWithUIColor:[UIColor clearColor]];
    config.lineWidth              = 1.f;
    
    return config;
}



+ (CGContextObjectConfig *)color_E1E1E1 {
    
    CGContextObjectConfig *config = [CGContextObjectConfig new];
    config.phase                  = 0;
    config.count                  = 2;
    config.strokeColor            = [RGBColor colorWithUIColor:[@"#E1E1E1" hexColor]];
    config.fillColor              = [RGBColor colorWithUIColor:[UIColor clearColor]];
    config.lineWidth              = 0.5f;
    
    return config;
}

@end
