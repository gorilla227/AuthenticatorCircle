//
//  InitialViewController.m
//  AuthenticatorCircle
//
//  Created by Andy on 15/8/24.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()
@property (nonatomic, strong) IBOutlet UILabel *lb_Description;
@property (nonatomic, strong) IBOutlet UIButton *btn_SetUp;
@property (nonatomic, strong) IBOutlet UIButton *btn_Restore;
@end

@implementation InitialViewController
@synthesize lb_Description, btn_SetUp, btn_Restore;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view.layer setContents:(id)[UIImage imageNamed:@"AppBackground.jpg"].CGImage];
    [self.view setContentMode:UIViewContentModeScaleAspectFill];
    [btn_SetUp.layer setCornerRadius:3.0f];
    [btn_SetUp.layer setMasksToBounds:YES];
    [btn_Restore.layer setCornerRadius:3.0f];
    [btn_Restore.layer setMasksToBounds:YES];
    [lb_Description sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_SetUp_OnClicked:(id)sender {
    ProcessingViewController *process = [self.storyboard instantiateViewControllerWithIdentifier:@"ProcessingViewController"];
    [process setProcessingType:ProcessingTypeSettingUp];
    [self presentViewController:process animated:YES completion:nil];
}

- (IBAction)btn_Restore_OnClicked:(id)sender {
#warning 
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
