//
//  SetUpAuthenticator.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/8/25.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "SetUpAuthenticator.h"

@interface SetUpAuthenticator ()
@property (nonatomic, strong) IBOutlet UILabel *lb_SerialNumber;
@property (nonatomic, strong) IBOutlet UILabel *lb_AuthenticatorCode;
@property (nonatomic, strong) IBOutlet UIProgressView *pv_ProgressView;
@property (nonatomic, strong) IBOutlet UILabel *lb_Instruction;
@property (nonatomic, strong) IBOutlet UIButton *btn_Continue;
@end

@implementation SetUpAuthenticator {
    AuthenticatorSimulator *authenticator;
}
@synthesize lb_SerialNumber, lb_AuthenticatorCode, pv_ProgressView, lb_Instruction, btn_Continue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    authenticator = appDelegate.gAuthenticator;
    
    [lb_SerialNumber setText:[authenticator retrieveSeriesNumber]];
    [btn_Continue.layer setCornerRadius:3.0f];
    [btn_Continue.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_Continue_OnClicked:(id)sender {
    
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
