//
//  ViewController.m
//  TestAVPlayer
//
//  Created by mac on 2017/8/8.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "ViewController.h"
#import "BottomView.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic,strong) BottomView *bottomView;
@property (nonatomic,strong) UIView     *statusBar;
@property (nonatomic,assign) BOOL        isFull;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self _creatUI];
 
    //设置静音模式播放声音
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    // 监听loadedTimeRanges属性
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_player.currentItem];
    //开启
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //APP运行状态通知，将要被挂起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appwillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    //APP运行状态通知，从后台进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appwillBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];


    
    
}

- (void)_creatUI{
    
    _bottomShow = YES;
    [self.playView.layer addSublayer:self.playerLayer];
    [self.playView addSubview:self.bottomView];
    _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];

    // 轻拍方法
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.playView addGestureRecognizer:tapGesture];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIView *)playView{
    if (!_playView) {
        
        CGRect rect = CGRectMake(0, 64,SCREEN_WIDTH , 200);
        _playView = [[UIView alloc]initWithFrame:rect];
        _playView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_playView];

    }
    return _playView;
}

- (UIActivityIndicatorView *)activity{
    if (!_activity) {

        _activity        = [[UIActivityIndicatorView alloc]init];
        _activity.frame = CGRectMake(SCREEN_WIDTH/2-15, self.playView.frame.size.height/2-15, 30, 30);
        [_activity startAnimating];
        [self.playView addSubview:_activity];

    }
    return _activity;
}

- (BottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BottomView alloc]init];
        _bottomView.frame = CGRectMake(0, self.playView.frame.size.height-40, self.playView.frame.size.width, 40);
        _bottomView.backgroundColor = [UIColor colorWithWhite:5 alpha:.5];
        __weak  typeof(self) weakSelf  = self;
        
        _bottomView.startDargBlock = ^{
            //暂停
            [weakSelf pausePlay];
        };
        
        _bottomView.changedDaryBlock = ^(ZWSlider *slider) {
            [weakSelf changeVideo:slider];
        };
        
        _bottomView.endDaryBlock = ^{
            [weakSelf playVideo];
        };
        
        _bottomView.playOrPauseBlock = ^(PlayImageType type) {
            
            _showTime = 0;
            
            if (type==playImage) {
                [weakSelf playVideo];
            }else{
                [weakSelf pausePlay];
            }
        };
    }
    return  _bottomView;
}



/**
 *  本地视频
 *
 *  @return AVPlayerItem对象
 */
//-(AVPlayerItem *)playerItem{
//    if (!_playerItem) {
//        
//        NSString *urlStr = [[NSBundle mainBundle]pathForResource:@"play" ofType:@"mp4"];
//        NSURL *url = [NSURL fileURLWithPath:urlStr];
//        AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
//        _playerItem=[AVPlayerItem playerItemWithAsset:asset];
//    }
//    return _playerItem;
//}


/**
 网络视频

 @return AVPlayerItem对象
 */
-(AVPlayerItem *)playerItem{
    if (!_playerItem) {
        NSURL *url = [NSURL URLWithString:@"http://dvideo.spriteapp.cn/video/2016/1118/582ee6ed3a5d6_wpc.mp4"];
        _playerItem=[AVPlayerItem playerItemWithURL:url];
    }
    return _playerItem;
}


- (AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = CGRectMake(0, 0, self.playView.frame.size.width, self.playView.frame.size.height);
        _playerLayer.videoGravity = AVLayerVideoGravityResize;
        [self.player play];
    }
    return _playerLayer;
}


//计算缓冲进度
- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - 缓存条监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        // 计算缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration             = _playerItem.duration;
        CGFloat totalDuration       = CMTimeGetSeconds(duration);
        CGFloat progress            = timeInterval / totalDuration;
        
//        NSLog(@"%.2f",progress);
        
        [self.bottomView.ProgressView setProgress:progress animated:NO];
        //设置缓存进度颜色
        self.bottomView.ProgressView.progressTintColor = [UIColor redColor];
    }
}


- (void)timerStart{
    
    if (_playerItem.duration.timescale != 0)
    {
        //总共时长
        self.bottomView.Slider.maximumValue = 1;
        //当前进度
        self.bottomView.Slider.value        = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);
        //当前时长进度progress
        NSInteger proMin     = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec     = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
        self.bottomView.minTimeLab.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        
        //duration 总时长
        NSInteger durMin     = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总分钟
        NSInteger durSec     = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总秒
        self.bottomView.maxTimeLab.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        
    }
    //开始播放停止转子
    if (self.player.status == AVPlayerStatusReadyToPlay)
    {
        [self.activity stopAnimating];
    }
    else
    {
        [self.activity startAnimating];
    }

    if (_showTime<7) {
        
        _showTime ++;
        [self _showBottomView];

    }
    
}

- (void)tapAction{
    _bottomShow = !_bottomShow;
    _showTime = 0;
    [self _showBottomView];
    
    if (!_isFull) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self.playView];
        [UIView animateWithDuration:0.1 animations:^{
            
            self.playView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
            self.playerLayer.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);

        }];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
  
    }else{
        
        [self.view addSubview:self.playView];

        [UIView animateWithDuration:0.1 animations:^{
            
            self.playView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 200);
            self.playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);

        }];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    
    _isFull = !_isFull;
    [self setStatusBarHidden:NO];

    
}

#pragma mark - 隐藏或者显示状态栏方法
- (void)setStatusBarHidden:(BOOL)hidden{
    //设置是否隐藏
    self.statusBar.hidden = hidden;
}

/**statusBar*/
- (UIView *) statusBar{
    if (_statusBar == nil){
        _statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    return _statusBar;
}


- (void)_showBottomView{
    
    
    if (self.bottomView) {
        if (_showTime>=7) {

                self.bottomView.hidden = YES;
                _bottomShow = NO;
                
        }else{
            if (!_bottomShow) {
                self.bottomView.hidden = YES;
            }else{
                self.bottomView.hidden = NO;
            }
        }
    }
    
}



// 视频播放完毕
- (void)moviePlayDidEnd{
    
    // 循环播放
    [_player seekToTime:CMTimeMake(0, 1)];
    [self playVideo];
    
}

// 开始播放
- (void)playVideo
{
    [_player play];
    
}

// 停止播放
- (void)pausePlay{
    [_player pause];
}


- (void)appwillResignActive{
    
    [self.bottomView changePlayActionBtnImage:pauseImage];
    
    [self pausePlay];
    
}

- (void)appwillBecomeActive{
    
    [self.bottomView changePlayActionBtnImage:playImage];
    
    [self playVideo];
}


- (void)changeVideo:(ZWSlider *)slider{
    _showTime = 0;
    
//    //计算出拖动的当前秒数
    CGFloat total           = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
    NSInteger dragedSeconds = floorf(total * slider.value);
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime     = CMTimeMake(dragedSeconds, 1);
    [self.player seekToTime:dragedCMTime];
    
}


#pragma mark - 销毁播放器
- (void)destroyPlayer
{
    //销毁定时器
    [self destroyAllTimer];
    //暂停
    [_player pause];
    //清除
    [_player.currentItem cancelPendingSeeks];
    [_player.currentItem.asset cancelLoading];
    //移除
    [self.playView removeFromSuperview];
    
}


#pragma mark - 取消定时器
//销毁所有定时器
- (void)destroyAllTimer
{
    [_sliderTimer invalidate];
    _sliderTimer = nil;
}


- (void)dealloc{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:_player.currentItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    NSLog(@"播放器被销毁了");
}


@end
