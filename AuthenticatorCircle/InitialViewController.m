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

@implementation InitialViewController {
    NSArray *regionCodes;
    NSDictionary *uiStrings;
}
@synthesize lb_Description, btn_SetUp, btn_Restore;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:cViewBackground];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [btn_SetUp.layer setCornerRadius:kButtonCornerRadius];
    [btn_SetUp.layer setMasksToBounds:YES];
    [btn_Restore.layer setCornerRadius:kButtonCornerRadius];
    [btn_Restore.layer setMasksToBounds:YES];
    [lb_Description sizeToFit];
    
    regionCodes = [gUIStrings objectForKey:@"SerialRegionCodes"];
    uiStrings = [gUIStrings objectForKey:@"UI_Initial"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)btn_SetUp_OnClicked:(id)sender {
    UIActionSheet *selectionRegioin = [[UIActionSheet alloc] initWithTitle:[uiStrings objectForKey:@"UI_Initial_SelectRegion_ActionSheetTitle"]
                                                                  delegate:self cancelButtonTitle:[uiStrings objectForKey:@"UI_Initial_SelectRegion_ActionSheetCancel"]
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:nil];
    for (NSString *region in regionCodes) {
        [selectionRegioin addButtonWithTitle:region];
    }
    [selectionRegioin showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self performSegueWithIdentifier:@"SetUpNewAuthenticator" sender:[actionSheet buttonTitleAtIndex:buttonIndex]];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SetUpNewAuthenticator"]) {
        ProcessingViewController *process = segue.destinationViewController;
        [process setProcessingType:ProcessingTypeSettingUp];
        [process setProcessingParameters:@{kSetupRegionCodeKey:sender}];
    }
}

@end
