//
//  BottomView.m
//  TestAVPlayer
//
//  Created by mac on 2017/8/10.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "BottomView.h"
#import "UIImage+ZWTintColor.h"
@implementation BottomView



- (void)drawRect:(CGRect)rect {
 [self _initComponents];

}


- (void)_initComponents{
    
    [self addSubview:self.PlayBtn];
    [self addSubview:self.minTimeLab];
    [self addSubview:self.maxTimeLab];
    [self addSubview:self.ProgressView];
    [self addSubview:self.Slider];
    [self sliderSetting];
}

- (UIButton *)PlayBtn{
    if (!_PlayBtn) {
        
        _PlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _PlayBtn.frame = CGRectMake(5, 4, 30, 30);
        _PlayBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_PlayBtn setImage:[UIImage imageNamed:@"CLPauseBtn"] forState:UIControlStateNormal];
        [_PlayBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _PlayBtn;
}

- (UILabel *)minTimeLab{
    if (!_minTimeLab) {
        _minTimeLab = [[UILabel alloc]init];
        _minTimeLab.font = [UIFont systemFontOfSize:10];
        _minTimeLab.textColor = [UIColor blackColor];
        _minTimeLab.text = @"00:00";
//        _minTimeLab.backgroundColor = [UIColor redColor];
        _minTimeLab.textAlignment = NSTextAlignmentCenter;
        _minTimeLab.frame = CGRectMake(_PlayBtn.frame.origin.x+35, 0, 50, 40);
    }
    return _minTimeLab;
}

- (UILabel *)maxTimeLab{
    if (!_maxTimeLab) {
        _maxTimeLab = [[UILabel alloc]init];
        _maxTimeLab.font = [UIFont systemFontOfSize:10];
        _maxTimeLab.textColor = [UIColor blackColor];
        _maxTimeLab.text = @"00:00";
//        _maxTimeLab.backgroundColor = [UIColor redColor];
        _maxTimeLab.textAlignment = NSTextAlignmentCenter;
        _maxTimeLab.frame = CGRectMake(self.frame.size.width-55, 0, 50, 40);
    }
    return _maxTimeLab;
}

- (ZWSlider *)Slider{
    if (!_Slider) {
        _Slider         = [[ZWSlider alloc]init];
//        _Slider.backgroundColor = [UIColor yellowColor];
        _Slider.maximumTrackTintColor = [UIColor clearColor];
        _Slider.frame   =  CGRectMake(90, 5.5,self.frame.size.width-110-35, 30);
    }
    return _Slider;
}

- (UIProgressView *)ProgressView{
    if (!_ProgressView) {
        _ProgressView = [[UIProgressView alloc]init];
        _ProgressView.frame = CGRectMake(90, 19,self.frame.size.width-110-35, 1);
        _ProgressView.trackTintColor = [UIColor colorWithWhite:5 alpha:.5];
    }
    return _ProgressView;
}


- (void)sliderSetting{
    
    UIImage *image     = [UIImage imageNamed:@"CLRound"];
    //通过改变图片大小来改变滑块大小
    UIImage *tempImage = [image OriginImage:image scaleToSize:CGSizeMake( 10, 10)];
    //通过改变图片颜色来改变滑块颜色
    UIImage *newImage  = [tempImage imageWithTintColor:[UIColor whiteColor]];
    [self.Slider setThumbImage:newImage forState:UIControlStateNormal];
    
    //开始拖拽
    [self.Slider addTarget:self action:@selector(processSliderStartDragAction:) forControlEvents:UIControlEventTouchDown];
    //拖拽中
    [self.Slider addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    //结束拖拽
    [self.Slider addTarget:self action:@selector(processSliderEndDragAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    
}

- (void)playVideo{
    if (_isPlay) {
        self.playOrPauseBlock(playImage);
        [self.PlayBtn setImage:[UIImage imageNamed:@"CLPauseBtn"] forState:UIControlStateNormal];
        _isPlay = NO;
    }else{
        self.playOrPauseBlock(pauseImage);
        [self.PlayBtn setImage:[UIImage imageNamed:@"CLPlayBtn"] forState:UIControlStateNormal];
        _isPlay = YES;
    }
    
    
}


- (void)processSliderStartDragAction:(ZWSlider *)slider{
    self.startDargBlock();
    
    [self.PlayBtn setImage:[UIImage imageNamed:@"CLPlayBtn"] forState:UIControlStateNormal];

}

- (void)sliderValueChangedAction:(ZWSlider *)slider{
    self.changedDaryBlock(slider);
}

- (void)processSliderEndDragAction:(ZWSlider *)slider{
    self.endDaryBlock();

    [self.PlayBtn setImage:[UIImage imageNamed:@"CLPauseBtn"] forState:UIControlStateNormal];

}


- (void)changePlayActionBtnImage:(PlayImageType)type{
    if (type==playImage) {
        [self.PlayBtn setImage:[UIImage imageNamed:@"CLPauseBtn"] forState:UIControlStateNormal];
        _isPlay = NO;
    }else{
        [self.PlayBtn setImage:[UIImage imageNamed:@"CLPlayBtn"] forState:UIControlStateNormal];
        _isPlay = YES;
    }
}


@end
