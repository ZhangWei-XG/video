//
//  UIImage+ZWTintColor.h
//  TestAVPlayer
//
//  Created by mac on 2017/8/10.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZWTintColor)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

/**
 重新绘制图片大小
 
 @param image 原始图片
 @param size  需要的大小
 
 @return 返回改变大小后图片
 */
-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size;



@end
