//
//  FamilyTripSmallVideoVC.h
//  BestLearning
//
//  Created by 星道 on 17/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyTripSmallVideoVC : UIViewController

/** 视频录制成功后，dismiss界面调这用个block ,VideoPath视频存放地址*/
@property (nonatomic, copy) void (^Complete)(NSString *VideoPath);

@end
