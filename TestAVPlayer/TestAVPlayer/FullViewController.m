//
//  FullViewController.m
//  TestAVPlayer
//
//  Created by mac on 2017/8/22.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "FullViewController.h"

@interface FullViewController ()

@end

@implementation FullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.playView.frame = self.view.bounds;
    
}


@end
