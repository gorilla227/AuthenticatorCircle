//
//  ViewRestoreCode.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/8/18.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "ViewRestoreCode.h"

@interface ViewRestoreCode ()
@property (nonatomic, strong) IBOutlet UILabel *lb_SerialTitle;
@property (nonatomic, strong) IBOutlet UILabel *lb_SerialNumber;
@property (nonatomic, strong) IBOutlet UILabel *lb_RestoreCodeTitle;
@property (nonatomic, strong) IBOutlet UILabel *lb_RestoreCodeNumber;
@property (nonatomic, strong) IBOutlet UILabel *lb_Notification;
@property (nonatomic, strong) IBOutlet UIButton *btn_SaveScreenshot;
@end

@implementation ViewRestoreCode {
    NSDictionary *uiStrings;
}
@synthesize lb_SerialTitle, lb_SerialNumber, lb_RestoreCodeTitle, lb_RestoreCodeNumber, lb_Notification, btn_SaveScreenshot;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    uiStrings = [gUIStrings objectForKey:@"UI_ViewRestoreCode"];
    
    [self.view setBackgroundColor:cBackground];
    [lb_SerialTitle setTextColor:[UIColor whiteColor]];
    [lb_SerialNumber setTextColor:[UIColor yellowColor]];
    [lb_RestoreCodeTitle setTextColor:[UIColor whiteColor]];
    [lb_RestoreCodeNumber setTextColor:[UIColor yellowColor]];
    [lb_Notification setTextColor:[UIColor whiteColor]];
    [btn_SaveScreenshot updateUIButtonStyle:UIButtonStyleLightBlue];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [lb_SerialNumber setText:[appDelegate.gAuthenticator retrieveSeriesNumber]];
    [lb_RestoreCodeNumber setText:[appDelegate.gAuthenticator retrieveRestoreCode]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[uiStrings objectForKey:@"UI_VRC_SaveScreenshot_Message"] delegate:nil cancelButtonTitle:[uiStrings objectForKey:@"UI_VRC_SaveScreenshot_CancelButton"] otherButtonTitles:nil];
        [alertView show];
    }
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
