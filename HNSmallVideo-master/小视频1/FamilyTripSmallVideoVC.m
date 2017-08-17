//
//  FamilyTripSmallVideoVC.m
//  BestLearning
//
//  Created by 星道 on 17/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FamilyTripSmallVideoVC.h"
#import <GPUImage.h>
#import "MeiYanFilter.h"

@interface FamilyTripSmallVideoVC ()
/** 摄像机 */
@property (nonatomic, strong) GPUImageVideoCamera *camera;
/** 显示摄影的界面 */
@property (nonatomic, strong) GPUImageView *cameraScreen;
/** 录制器 */
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;

/** 美颜 */
@property (nonatomic, strong) MeiYanFilter *meiYan;

/** 开始、停止 */
@property (nonatomic, strong) UIButton *beginAndStop_Btn;
@end
/** 视频所在的地址 */
#define MoviePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Movie.m4v"]

@implementation FamilyTripSmallVideoVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 初始化GPUImage的相机功能，同时设置高清画设置，以及使用前置摄像头
    self.camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];

    // 设置镜头的方向，这里设的正常竖立的
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;

    // 这两句是使用系统相机的设置，如何是否镜像之类
    self.camera.horizontallyMirrorRearFacingCamera = NO;
    self.camera.horizontallyMirrorFrontFacingCamera = YES;

    // 该句可防止允许声音通过的情况下，避免录制第一帧黑屏闪屏(====)
    [self.camera addAudioInputsAndOutputs];

    // 创建摄像头预览视图，也可以在XiB拖个UIView，继承GPUImageView，也可以
    self.cameraScreen = [[GPUImageView alloc] initWithFrame:self.view.frame];

    // 添加到父视图上去
    [self.view addSubview:self.cameraScreen];

    //显示模式充满整个边框，也就是留黑边
    self.cameraScreen.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;

    // 栽掉多余的画画，具体效果自己比对下
    self.cameraScreen.clipsToBounds = YES;
    [self.cameraScreen.layer setMasksToBounds:YES];

    // 往相机里添加美颜的效果
    [self.camera addTarget:self.meiYan];

    // 预览视图里加入美颜
    [self.meiYan addTarget:self.cameraScreen];

    // 相机开始预览啦
    [self.camera startCameraCapture];

    // 如果已经存在文件，AVAssetWriter会有异常，删除旧文件 ，*重点
    unlink([MoviePath UTF8String]);

    // 初始化这个地址，不能UrlWithString的方法
    NSURL *willSaveURL = [NSURL fileURLWithPath:MoviePath];

    // 初始化视频制作操作，传入视频保存的url，以及显示范围的大小
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:willSaveURL size:self.view.bounds.size];

    // 自动控制声音与图像一致
    self.movieWriter.encodingLiveVideo = YES;
    self.movieWriter.shouldPassthroughAudio = YES;
    self.movieWriter.hasAudioTrack = YES;

    // 把美颜效果也写入到这个操作
    [self.meiYan addTarget:self.movieWriter];

    // 把这个视频的操作放进相机里面
    self.camera.audioEncodingTarget = self.movieWriter;


    // 放个开始录制和停止录制的按钮
    [self beginAndStop_Btn];
}



/** 点击了按钮 */
- (void)StartOrStop:(UIButton *)sender
{
    sender.selected = !sender.selected;
    // 根据状态调用开始或停止的功能
    sender.selected ? [self Start]:[self Close];
}

/** 开始录制 */
- (void)Start
{
    [self.movieWriter startRecording];
}

/** 停止录制 */
- (void)Close
{
    // 移除相机里的录制
    self.camera.audioEncodingTarget = nil;

    // 录制操作设为完成
    [self.movieWriter finishRecording];

    // 美颜效果里移除掉录制操作
    [self.meiYan removeTarget:self.movieWriter];

    // 将这个地址传出去
    if (self.Complete)
    {
        self.Complete (MoviePath);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}




// 美颜滤镜的懒加载
- (MeiYanFilter *)meiYan
{
    if (!_meiYan)
    {
        _meiYan = [[MeiYanFilter alloc] init];
    }
    return _meiYan;
}

- (UIButton *)beginAndStop_Btn
{
    if (!_beginAndStop_Btn)
    {
        _beginAndStop_Btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_beginAndStop_Btn setTitle:@"开始" forState:(UIControlStateNormal)];
        [_beginAndStop_Btn setTitle:@"停止" forState:(UIControlStateSelected)];
        [_beginAndStop_Btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_beginAndStop_Btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        [_beginAndStop_Btn addTarget:self action:@selector(StartOrStop:) forControlEvents:(UIControlEventTouchUpInside)];
        CGFloat X = 0;
        CGFloat Y = 0;
        CGFloat W = 100;
        CGFloat H = 100;
        _beginAndStop_Btn.frame = CGRectMake(X, Y, W, H);
        _beginAndStop_Btn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 100);
        [self.view addSubview:_beginAndStop_Btn];

    }
    return _beginAndStop_Btn;
}
@end
