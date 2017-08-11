//
//  ZWSlider.m
//  TestAVPlayer
//
//  Created by mac on 2017/8/10.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "ZWSlider.h"

@implementation ZWSlider

// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    [super trackRectForBounds:bounds];
    return CGRectMake(-2, (self.frame.size.height - 3)/2.0, CGRectGetWidth(bounds) + 4, 2);
}



@end
