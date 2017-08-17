//
//  ViewController.m
//  HNSmallVideo-master
//
//  Created by 星道 on 17/8/17.
//  Copyright © 2017年 星道三好. All rights reserved.
//

#import "ViewController.h"

#import "FamilyTripSmallVideoVC.h"

@interface ViewController ()
{
    IBOutlet UIButton *_VideoStatus_Btn;
}
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


}


/** 进入相机 */
- (IBAction)GoCamera:(UIButton *)sender
{
    // 实例化控制器
    FamilyTripSmallVideoVC *VC = [[FamilyTripSmallVideoVC alloc] init];
    [self presentViewController:VC animated:YES completion:nil];

    // 视频拍摄完成后的回调
    VC.Complete = ^(NSString *VideoPath) {

        UISaveVideoAtPathToSavedPhotosAlbum(VideoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    };
}



// 视频保存完毕回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
    NSLog(@"视频保存的地址:%@",videoPath);
    _VideoStatus_Btn.selected = YES;
}
@end
