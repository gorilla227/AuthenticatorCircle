//
//  WelcomeHomePage.m
//  AuthenticatorCircle
//
//  Created by Andy on 15/9/16.
//  Copyright © 2015年 Andy Xu. All rights reserved.
//

#import "WelcomeHomePage.h"

@interface WelcomeHomePage ()
@property (nonatomic, strong) IBOutlet UIImageView *iv_WelcomeIcon;
@end

@implementation WelcomeHomePage
@synthesize iv_WelcomeIcon;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [iv_WelcomeIcon setTransform:CGAffineTransformMakeScale(1.5f, 1.5f)];
    [iv_WelcomeIcon setAlpha:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5f animations:^{
        [iv_WelcomeIcon setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
        [iv_WelcomeIcon setAlpha:1.0f];
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
