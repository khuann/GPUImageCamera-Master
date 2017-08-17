//
//  MeiYanFilter.m
//  BestLearning
//
//  Created by 星道 on 17/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MeiYanFilter.h"

@implementation MeiYanFilter

- (instancetype)init
{
    self = [super init];
    if (self)
    {

        //  5.磨皮滤镜
        GPUImageBilateralFilter *bilateralFilter = [[GPUImageBilateralFilter alloc] init];
        [self addFilter:bilateralFilter];

        //  6.美白滤镜
        GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        brightnessFilter.brightness = 0.08f;
        [self addFilter:brightnessFilter];

        //  7.设置滤镜组链
        [bilateralFilter addTarget:brightnessFilter];
        [self setInitialFilters:@[bilateralFilter]];
        self.terminalFilter = brightnessFilter;

    }
    return self;
}

@end
