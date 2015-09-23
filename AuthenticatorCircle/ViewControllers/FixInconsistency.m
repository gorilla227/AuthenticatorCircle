//
//  FixInconsistency.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/9/19.
//  Copyright © 2015年 Andy Xu. All rights reserved.
//

#import "FixInconsistency.h"

@interface FixInconsistency ()
@property (nonatomic, strong) IBOutlet UIImageView *iv_WarningSign;
@property (nonatomic, strong) IBOutlet UILabel *lb_LocalDate;
@property (nonatomic, strong) IBOutlet UILabel *lb_LocalSerial;
@property (nonatomic, strong) IBOutlet UILabel *lb_CloudDate;
@property (nonatomic, strong) IBOutlet UILabel *lb_CloudSerial;
@property (nonatomic, strong) IBOutlet UIButton *btn_UseLocal;
@property (nonatomic, strong) IBOutlet UIButton *btn_UseCloud;
@end

@implementation FixInconsistency {
    AuthenticatorSimulator *localAuthenticator;
    AuthenticatorSimulator *cloudAuthenticator;
}
@synthesize iv_WarningSign, lb_CloudDate, lb_CloudSerial, lb_LocalDate, lb_LocalSerial, btn_UseCloud, btn_UseLocal;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIView animateWithDuration:1.5f delay:0.0f options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [iv_WarningSign setTransform:CGAffineTransformMakeScale(1.05f, 1.05f)];
    } completion:nil];
    [btn_UseLocal updateUIButtonStyle:UIButtonStyleLightBlue];
    [btn_UseCloud updateUIButtonStyle:UIButtonStyleLightBlue];
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
    NSDate *cloudLastModificationDate = [AuthenticatorOperation lastModificationDateOfCloud];
    NSDate *localLastModificationDate = [AuthenticatorOperation lastModificationDateOfLocalFile:filePath];
    localAuthenticator = [AuthenticatorOperation loadFromFile:filePath];
    cloudAuthenticator = [AuthenticatorOperation loadFromCloud];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [lb_LocalDate setText:[dateFormatter stringFromDate:localLastModificationDate]];
    [lb_CloudDate setText:[dateFormatter stringFromDate:cloudLastModificationDate]];
    [lb_LocalSerial setText:[NSString stringWithFormat:NSLocalizedString(@"UI_FI_Serial", @"Serial Number"), [localAuthenticator retrieveSeriesNumber]]];
    [lb_CloudSerial setText:[NSString stringWithFormat:NSLocalizedString(@"UI_FI_Serial", @"Serial Number"), [cloudAuthenticator retrieveSeriesNumber]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, btn_UseCloud.frame.origin.y + btn_UseCloud.frame.size.height + 20)];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)btn_UseLocal_OnClicked:(id)sender {
    ProcessingViewController *processing = [self.storyboard instantiateViewControllerWithIdentifier:@"ProcessingViewController"];
    [processing setProcessingType:ProcessingTypeFixInconsistency];
    [processing setProcessingParameters:@{kFixInconsistencyAuthenticatorKey:localAuthenticator, kFixInconsistencySaveCloudKey:@YES}];
    [self presentViewController:processing animated:YES completion:nil];
}

- (IBAction)btn_UseCloud_OnClicked:(id)sender {
    ProcessingViewController *processing = [self.storyboard instantiateViewControllerWithIdentifier:@"ProcessingViewController"];
    [processing setProcessingType:ProcessingTypeFixInconsistency];
    [processing setProcessingParameters:@{kFixInconsistencyAuthenticatorKey:cloudAuthenticator, kFixInconsistencySaveCloudKey:@NO}];
    [self presentViewController:processing animated:YES completion:nil];
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
