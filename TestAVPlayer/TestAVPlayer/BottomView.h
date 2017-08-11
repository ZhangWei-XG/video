//
//  BottomView.h
//  TestAVPlayer
//
//  Created by mac on 2017/8/10.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWSlider.h"

typedef NS_ENUM(NSInteger, PlayImageType) {
    playImage,//默认从0开始
    pauseImage,
};

@interface BottomView : UIView

/** playbtn*/
@property (nonatomic, strong) UIButton  *PlayBtn;

/** 进度条*/
@property (nonatomic, strong) ZWSlider  *Slider;

/** maxScreen*/
@property (nonatomic, strong) UIButton  *MaxBtn;

/** minTime*/
@property (nonatomic, strong) UILabel   *minTimeLab;

/** maxTime*/
@property (nonatomic, strong) UILabel   *maxTimeLab;

/** progress*/
@property (nonatomic, strong) UIProgressView  *ProgressView;

/** startDarg*/
@property (nonatomic, copy) void(^startDargBlock)();

/** endDary*/
@property (nonatomic, copy) void(^changedDaryBlock)(ZWSlider *slider);

/** endDary*/
@property (nonatomic, copy) void(^endDaryBlock)();

/** 播放、暂停*/
@property (nonatomic, copy) void(^playOrPauseBlock)(PlayImageType type);

/** 标记播放状态*/
@property (nonatomic, assign) BOOL  isPlay;


/**
 改变播放按钮的图片
 */
- (void)changePlayActionBtnImage:(PlayImageType)type;



@end
