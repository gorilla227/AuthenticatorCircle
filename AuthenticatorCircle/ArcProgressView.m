//
//  ArcProgressView.m
//  AXU_CircleProgressBar
//
//  Created by Andy Xu on 15/4/1.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "ArcProgressView.h"

@implementation ArcProgressView {
    CGFloat arcDiameter;
    CGFloat arcWidth;
    CGFloat arcAngle;
    CGFloat radius;
    CAShapeLayer *progressBarBackgroundLayer;
    CAShapeLayer *progressBarLayer;
    UILabel *labelProgress;
    NSInteger progressNumber;
    NSInteger targetProgress;
    BOOL isAscendProgress;
    NSTimer *mainTimer;
    UILabel *countDownLabel;
    UIVisualEffectView *blurEffectView;
}
@synthesize currentProgress, progressBarBackgroundColor, isAnimating;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithDiameter:(CGFloat)diameter arcWidth:(CGFloat)width arcRadian:(CGFloat)angle {
    self = [super initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    if (self) {
        arcDiameter = diameter;
        arcWidth = width;
        arcAngle = angle;
        radius = (diameter - width) / 2;
        
        [self addObserver:self forKeyPath:@"progressBarBackgroundColor" options:NSKeyValueObservingOptionInitial context:nil];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:(arcDiameter - arcWidth)/2 startAngle:degressToRadians(90 - arcAngle / 2) endAngle:degressToRadians(arcAngle / 2 + 90) clockwise:YES];
        
        //Draw Background
        if (!progressBarBackgroundColor) {
            progressBarBackgroundColor = [UIColor darkGrayColor];
        }
        progressBarBackgroundLayer = [CAShapeLayer layer];
        [progressBarBackgroundLayer setFrame:self.bounds];
        [progressBarBackgroundLayer setFillColor:[UIColor clearColor].CGColor];
        [progressBarBackgroundLayer setStrokeColor:progressBarBackgroundColor.CGColor];
        [progressBarBackgroundLayer setOpacity:1.0f];
        [progressBarBackgroundLayer setLineCap:kCALineCapRound];
        [progressBarBackgroundLayer setLineWidth:arcWidth];
        [progressBarBackgroundLayer setPath:path.CGPath];
        [self.layer addSublayer:progressBarBackgroundLayer];
        
        //Draw ProgressBar Layer
        progressBarLayer = [CAShapeLayer layer];
        [progressBarLayer setFrame:progressBarBackgroundLayer.bounds];
        [progressBarLayer setFillColor:[UIColor clearColor].CGColor];
        [progressBarLayer setStrokeColor:[UIColor greenColor].CGColor];
        [progressBarLayer setLineCap:kCALineCapRound];
        [progressBarLayer setLineWidth:arcWidth];
        [progressBarLayer setPath:path.CGPath];
        [progressBarLayer setStrokeEnd:0.0f];
        [self.layer addSublayer:progressBarLayer];
        
        //Label Initialization
        labelProgress = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (arcDiameter - arcWidth) / sqrtf(2), (arcDiameter - arcWidth) / sqrtf(2))];
        [labelProgress setCenter:self.center];
        [labelProgress setText:[NSString stringWithFormat:@"%.f%%", currentProgress * 100]];
        [labelProgress setAdjustsFontSizeToFitWidth:YES];
        [labelProgress setTextAlignment:NSTextAlignmentCenter];
        [labelProgress setFont:[UIFont systemFontOfSize:25.0f]];
        [labelProgress setLineBreakMode:NSLineBreakByClipping];
        [labelProgress setNumberOfLines:1];
        [labelProgress setMinimumScaleFactor:0.5];
        [self addSubview:labelProgress];
        
        //Initial CountDownLabel
        countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [countDownLabel.layer setCornerRadius:15];
        [countDownLabel.layer setMasksToBounds:YES];
        [countDownLabel setBackgroundColor:[UIColor redColor]];
        [countDownLabel setTextColor:[UIColor whiteColor]];
        [countDownLabel setTextAlignment:NSTextAlignmentCenter];
        [countDownLabel setFont:[UIFont systemFontOfSize:20.0f]];
        [countDownLabel setCenter:self.center];
        [self addSubview:countDownLabel];
        
        //BlurEffect
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [blurEffectView setFrame:CGRectMake(-5.0f, -5.0f, arcDiameter + 10.0f, arcDiameter + 10.0f)];
        [blurEffectView.layer setCornerRadius:arcDiameter / 2 + 5.0f];
        [blurEffectView.layer setMasksToBounds:YES];
        [self insertSubview:blurEffectView atIndex:0];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"progressBarBackgroundColor"]) {
        [progressBarBackgroundLayer setStrokeColor:progressBarBackgroundColor.CGColor];
    }
}

- (void)changeProgress:(CGFloat)progress isAnimated:(BOOL)animated {
    if (progress < 0) {
        progress = 0;
    }
    else if (progress > 1) {
        progress = 1;
    }

    if (progress != progressBarLayer.strokeEnd) {
        if (animated) {
            progressNumber = progressBarLayer.strokeEnd * 100;
            targetProgress = progress * 100;
            isAscendProgress = (targetProgress > progressNumber)?YES:NO;
            
            [CATransaction begin];
            [CATransaction setDisableActions:NO];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [CATransaction setAnimationDuration:kAnimationDuration];
            [progressBarLayer setStrokeEnd:isAscendProgress?progressBarLayer.strokeEnd+0.01:progressBarLayer.strokeEnd-0.01];
            [CATransaction commit];
        }
        else {
            [labelProgress setText:[NSString stringWithFormat:@"%.f%%", progress * 100]];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [CATransaction setAnimationDuration:kAnimationDuration];
            [progressBarLayer setStrokeEnd:progress];
            [CATransaction commit];
        }
    }
}

- (CGFloat)currentProgress {
    return progressBarLayer.strokeEnd;
}

- (BOOL)isAnimating {
    return mainTimer.valid;
}

- (void)startAnimation {
    if (!mainTimer || !mainTimer.valid) {
        mainTimer = [NSTimer scheduledTimerWithTimeInterval:kAnimationDuration target:self selector:@selector(timerTicked) userInfo:nil repeats:YES];
    }
    [mainTimer fire];
}

- (void)timerTicked {
    if (progressBarLayer.strokeEnd >= 0.999f) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [CATransaction setAnimationDuration:kAnimationDuration];
        [progressBarLayer setStrokeEnd:0.0f];
        [CATransaction commit];
        [progressBarLayer setStrokeColor:[UIColor greenColor].CGColor];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRepeatNotification object:self];
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:kAnimationDuration];
    [progressBarLayer setStrokeEnd:progressBarLayer.strokeEnd + kAnimationPercentag];
    
    [CATransaction commit];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:kAnimationDuration];
    CGPoint countDownCenter = CGPointMake(radius * sin(degressToRadians(360.0f * progressBarLayer.strokeEnd)) + self.bounds.size.width / 2, self.bounds.size.height / 2 - radius * cos(degressToRadians(360.0f * progressBarLayer.strokeEnd)));
    [countDownLabel setCenter:countDownCenter];
    
    NSInteger number = ceil((1 - progressBarLayer.strokeEnd) * kAnimationDuration / kAnimationPercentag);
    if (number >= 1 && number <= 5) {
        [countDownLabel setText:[NSString stringWithFormat:@"%lu", number]];
    }
    else {
        [countDownLabel setText:nil];
    }
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:kAnimationDuration * 10];
    if (number <= 5) {
        [countDownLabel setTransform:CGAffineTransformMakeScale(1, 1)];
    }
    else {
        [countDownLabel setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
    }
    [UIView commitAnimations];

    //Change Progress Color
    if (progressBarLayer.strokeEnd > 0.5f) {
        UIColor *progressColor = [self colorOfGradient:1 / kAnimationPercentag / 2 position:ceil((progressBarLayer.strokeEnd - 0.5) / kAnimationPercentag)];
//        NSLog(@"%f, %d", progressBarLayer.strokeEnd, (int)ceil((progressBarLayer.strokeEnd - 0.5) / kAnimationPercentag));
        [progressBarLayer setStrokeColor:progressColor.CGColor];
    }
}

- (void)stopAnimation {
    [mainTimer invalidate];
}

- (void)showOrHiddenProgressLabel:(BOOL)isShowProgressLabel countDownLabel:(BOOL)isShowCountDownLabel {
    [labelProgress setHidden:!isShowProgressLabel];
    [countDownLabel setHidden:!isShowCountDownLabel];
}

- (UIColor *)colorOfGradient:(NSInteger)granularity position:(NSInteger)position {
    CAGradientLayer *sampleLayer = [CAGradientLayer layer];
    [sampleLayer setFrame:CGRectMake(0, 0, 1, granularity)];
    [sampleLayer setColors:@[(id)[UIColor greenColor].CGColor, (id)[UIColor orangeColor].CGColor, (id)[UIColor redColor].CGColor]];
    
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, 0, -position);
    [sampleLayer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    return color;
}
@end
