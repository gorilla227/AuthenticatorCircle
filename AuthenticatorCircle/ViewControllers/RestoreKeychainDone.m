//
//  RestoreKeychainDone.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/9/10.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "RestoreKeychainDone.h"

@interface RestoreKeychainDone ()
@property (nonatomic, strong) IBOutlet UIImageView *iv_CompleteSign;
@property (nonatomic, strong) IBOutlet UIButton *btn_Continue;
@end

@implementation RestoreKeychainDone
@synthesize iv_CompleteSign, btn_Continue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:cViewBackground];
    [btn_Continue updateUIButtonStyle:UIButtonStyleLightBlue];
    [iv_CompleteSign setTransform:CGAffineTransformMakeScale(1.2f, 1.2f)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [iv_CompleteSign setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
    } completion:nil];
}

- (IBAction)btn_Continue_OnClicked:(id)sender {
    UIViewController *mainViewController = [self.storyboard instantiateInitialViewController];
    [self presentViewController:mainViewController animated:YES completion:nil];
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
