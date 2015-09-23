//
//  ArcProgressView.h
//  AXU_CircleProgressBar
//
//  Created by Andy Xu on 15/4/1.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#define degressToRadians(x) (M_PI*(x)/180.0)
#define kAnimationDuration 0.03f
#define kAnimationPercentag 0.001f
#define kRepeatNotification @"CirculationStart"
#import <UIKit/UIKit.h>

@interface ArcProgressView : UIView
@property (readonly) CGFloat currentProgress;
@property (nonatomic) UIColor *progressBarBackgroundColor;
@property (readonly) BOOL isAnimating;
- (id)initWithDiameter:(CGFloat)diameter arcWidth:(CGFloat)width arcRadian:(CGFloat)angle;
- (void)changeProgress:(CGFloat)progress isAnimated:(BOOL)animated;
- (void)startAnimation;
- (void)stopAnimation;
- (void)showOrHiddenProgressLabel:(BOOL)isShowProgressLabel countDownLabel:(BOOL)isShowCountDownLabel;
@end
