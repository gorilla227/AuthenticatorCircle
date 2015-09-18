//
//  WelcomeSyncWithiCloud.m
//  AuthenticatorCircle
//
//  Created by Andy on 15/9/16.
//  Copyright © 2015年 Andy Xu. All rights reserved.
//

#import "WelcomeSyncWithiCloud.h"

@interface WelcomeSyncWithiCloud ()
@property (nonatomic, strong) IBOutlet UIImageView *iv_Cloud;
@property (nonatomic, strong) IBOutlet UIButton *btn_LearnHow;
@property (nonatomic, strong) IBOutlet UIButton *btn_Continue;
@end

@implementation WelcomeSyncWithiCloud
@synthesize iv_Cloud, btn_LearnHow, btn_Continue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [iv_Cloud setTransform:CGAffineTransformMakeScale(1.5f, 1.5f)];
    [iv_Cloud setAlpha:0];
    
    [btn_LearnHow updateUIButtonStyle:UIButtonStyleDarkBlue2];
    [btn_Continue updateUIButtonStyle:UIButtonStyleLightBlue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5f animations:^{
        [iv_Cloud setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
        [iv_Cloud setAlpha:1.0f];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
