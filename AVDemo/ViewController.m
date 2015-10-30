//
//  ViewController.m
//  AVDemo
//
//  Created by 中软mini025 on 15/10/29.
//  Copyright (c) 2015年 中软mini025. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#define music_name @"站起来"
#define stopBtn_tag 1000
#define btn_tag 1001

@interface ViewController ()<AVAudioPlayerDelegate>
{
    UISlider* rate;
    NSTimer* timer;
    
}
@property (nonatomic,assign)BOOL flag;
@property (nonatomic, strong)AVAudioPlayer* player;
@property (nonatomic, strong)NSURL* url;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flag = NO;
    [self initUI];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(AVAudioPlayer*)player
{
    if (_player == nil) {
        NSError* err = nil;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.url error:&err];
        
        //启动后台会话，可以后台播放
        AVAudioSession* audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
        [audioSession setActive:YES error:&err];
        
        _player.delegate = self;
        if (_player&&err == nil) {
            [_player prepareToPlay];
        }
    }
    return _player;
}

-(NSURL*)url
{
    if (_url==nil) {
        _url = [[NSBundle mainBundle] URLForResource:music_name withExtension:@"mp3"];
    }
    return _url;
}
-(void)initUI
{

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"成龙.jpg"]];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.height-200, 100, 40)];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    btn.tag = btn_tag;
    [self.view addSubview:btn];
    
    UIButton* stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(btn.frame)+10, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame))];
    [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    stopBtn.tag = stopBtn_tag;
    stopBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:stopBtn];
    
    rate = [[UISlider alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-260, [UIScreen mainScreen].bounds.size.width, 10)];
    rate.continuous = NO;
    rate.userInteractionEnabled = YES;
    rate.minimumValue = 0;
    rate.maximumValue = self.player.duration;
    NSLog(@"%f",self.player.duration);
    [rate addTarget:self action:@selector(diplaySlider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:rate];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(diplaySliderWithTimer:) userInfo:nil repeats:YES];
}

-(void)diplaySlider:(id)sender
{
    self.player.currentTime = rate.value;

}

-(void)diplaySliderWithTimer:(id)sender
{
    rate.value = self.player.currentTime;
}

-(void)btnClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    switch (btn.tag) {
        case btn_tag:
        {
            [self startBtnEvent:btn];
        }
            break;
        case stopBtn_tag:
        {
            [self.player stop];
            self.player.currentTime = 0;
            UIButton* btn = (UIButton*)[self.view viewWithTag:btn_tag];
            [btn setTitle:@"开始" forState:UIControlStateNormal];
            self.flag = NO;
        }
            break;
        default:
            break;
    }
    
    
    
}

-(void)startBtnEvent:(UIButton*)btn
{
    if (self.flag) {
        [self.player pause];
        [btn setTitle:@"开始" forState:UIControlStateNormal];
        self.flag = NO;
    }else{
        [self.player play];
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
        self.flag = YES;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    UIButton* btn = (UIButton*)[self.view viewWithTag:btn_tag];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    self.flag = NO;
    
}
@end
