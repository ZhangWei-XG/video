//
//  ViewController.h
//  TestAVPlayer
//
//  Created by mac on 2017/8/8.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController


/** 播放器容器*/
@property (nonatomic, strong) UIView  *playView;

/** playitem*/
@property (nonatomic, strong) AVPlayerItem  *playerItem;


/** 播放器对象*/
@property (nonatomic, strong) AVPlayer *player;

/** playerLayer*/
@property (nonatomic, strong) AVPlayerLayer  *playerLayer;

/** 计时器*/
@property (nonatomic, strong) NSTimer  *sliderTimer;

/** 菊花*/
@property (nonatomic,strong) UIActivityIndicatorView *activity;

/** 记录底部View隐藏和显示*/
@property (nonatomic, assign) BOOL  bottomShow;

/** 记录底部View显示时长*/
@property (nonatomic, assign) NSInteger  showTime;



@end

