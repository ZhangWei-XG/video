//
//  UIImage+ZWTintColor.m
//  TestAVPlayer
//
//  Created by mac on 2017/8/10.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "UIImage+ZWTintColor.h"

@implementation UIImage (ZWTintColor)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor

{
    
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
    
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor

{
    
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
    
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode

{
    
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    [tintColor setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
        
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tintedImage;
    
}

-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size
{
    //size为CGSize类型，即你所需要的图片尺寸
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}



@end
