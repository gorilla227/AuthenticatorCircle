//
//  SetUpAuthenticatorDone.m
//  AuthenticatorCircle
//
//  Created by Andy on 15/8/29.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "SetUpAuthenticatorDone.h"

@interface SetUpAuthenticatorDone ()
@property (nonatomic, strong) IBOutlet UILabel *lb_YouAreDone;
@property (nonatomic, strong) IBOutlet UILabel *lb_Description;
@property (nonatomic, strong) IBOutlet UILabel *lb_SerialTitle;
@property (nonatomic, strong) IBOutlet UILabel *lb_SerialNumber;
@property (nonatomic, strong) IBOutlet UILabel *lb_RestoreTitle;
@property (nonatomic, strong) IBOutlet UILabel *lb_RestoreCode;
@property (nonatomic, strong) IBOutlet UIButton *btn_SaveScreenshot;
@property (nonatomic, strong) IBOutlet UIButton *btn_Continue;
@end

@implementation SetUpAuthenticatorDone {
    AuthenticatorSimulator *authenticator;
    NSDictionary *uiStrings;
}
@synthesize lb_YouAreDone, lb_Description, lb_SerialTitle, lb_SerialNumber, lb_RestoreTitle, lb_RestoreCode, btn_SaveScreenshot, btn_Continue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    uiStrings = [gUIStrings objectForKey:@"UI_SetUpAuthenticatorDone"];
    [btn_SaveScreenshot updateUIButtonStyle:UIButtonStyleDarkBlue1];
    [btn_Continue updateUIButtonStyle:UIButtonStyleLightBlue];
    [self.view setBackgroundColor:cViewBackground];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    authenticator = appDelegate.gAuthenticator;
    [lb_SerialNumber setText:[authenticator retrieveSeriesNumber]];
    [lb_RestoreCode setText:[authenticator retrieveRestoreCode]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)btn_SaveScreenshot_OnClicked:(id)sender {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(screenshot, self, @selector(screenshot:didFinishSavingWithError:contextInfo:), nil);
}

- (void)screenshot:(UIImage *)screenshot didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[uiStrings objectForKey:@"UI_SUAD_SaveScreenshot_Message"] delegate:nil cancelButtonTitle:[uiStrings objectForKey:@"UI_SUAD_SaveScreenshot_CancelButton"] otherButtonTitles:nil];
        [alertView show];
    }
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
