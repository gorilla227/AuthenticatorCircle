//
//  ProcessingViewController.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/8/24.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "ProcessingViewController.h"

@interface ProcessingViewController ()
@property (nonatomic, strong) IBOutlet UILabel *lb_Processing;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *ai_Processing;
@end

@implementation ProcessingViewController
@synthesize lb_Processing, ai_Processing, processingType, processingParameters;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:cViewBackground];
    [self.navigationController setNavigationBarHidden:YES];
    switch (processingType) {
        case ProcessingTypeResetting:
            [lb_Processing setText:NSLocalizedString(@"UI_Processing_Resetting", @"Resetting")];
            break;
        case ProcessingTypeSettingUp:
            [lb_Processing setText:NSLocalizedString(@"UI_Processing_SettingUp", @"SettingUp")];
            break;
        case ProcessingTypeRestoreWithCode:
        case ProcessingTypeRestoreKeychain:
        case ProcessingTypeFixInconsistency:
            [lb_Processing setText:NSLocalizedString(@"UI_Processing_Restoring", @"Restoring")];
            break;
        default:
            [lb_Processing setText:nil];
            break;
    }
    [ai_Processing startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(completeProcess) userInfo:nil repeats:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)completeProcess {
    [ai_Processing stopAnimating];
    if (processingType == ProcessingTypeResetting) {
        //Reset authenticator
        AppDelegate *appDeldgate = [[UIApplication sharedApplication] delegate];
        [appDeldgate setGAuthenticator:nil];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
        [AuthenticatorOperation clearLocalFile:filePath];

        UIViewController *initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialNavi"];
        [self presentViewController:initialViewController animated:YES completion:nil];
    }
    else if (processingType == ProcessingTypeSettingUp) {
        //Set up new Authenticator
        AuthenticatorSimulator *newAuthenticator = [[AuthenticatorSimulator alloc] initWithSeriesNumber:[processingParameters objectForKey:kSetupRegionCodeKey] andRestoreCode:nil];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
        if ([AuthenticatorOperation save:newAuthenticator toFile:filePath] && [AuthenticatorOperation saveToCloud:newAuthenticator]) {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate setGAuthenticator:newAuthenticator];
            
            [self performSegueWithIdentifier:@"SetUpNewAuthenticator" sender:nil];
        }
    }
    else if (processingType == ProcessingTypeRestoreKeychain) {
        //Restore from iCloud
        AuthenticatorSimulator *authenticator = [AuthenticatorOperation loadFromCloud];
        if (authenticator) {
            NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
            [AuthenticatorOperation save:authenticator toFile:filePath];
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate setGAuthenticator:authenticator];
            
            [self performSegueWithIdentifier:@"RestoreKeychainDone" sender:self];
        }
        else {
            //No Authenticator saved in iCloud
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"UI_Processing_NotFoundAuthenticatorOnCloud_Warning", @"Not found authenticator on iCloud.")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"UI_Processing_NotFoundAuthenticatorOnCloud_CancelButton", @"Cancel")
                                                      otherButtonTitles:NSLocalizedString(@"UI_Processing_NotFoundAuthenticatorOnCloud_TryAgainButton", @"Try Again"), nil];
            [alertView show];
        }
    }
    else if (processingType == ProcessingTypeRestoreWithCode) {
        //Restore with Serial & RestoreCode
        if ([processingParameters.allKeys containsObject:kSerialKey] && [processingParameters.allKeys containsObject:kRestoreCodeKey]) {
            AuthenticatorSimulator *authenticator = [[AuthenticatorSimulator alloc] initWithSeriesNumber:[processingParameters objectForKey:kSerialKey] andRestoreCode:[processingParameters objectForKey:kRestoreCodeKey]];
            NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
            if ([AuthenticatorOperation save:authenticator toFile:filePath] && [AuthenticatorOperation saveToCloud:authenticator]) {
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                [appDelegate setGAuthenticator:authenticator];
                
                UIViewController *mainViewController = [self.storyboard instantiateInitialViewController];
                [self presentViewController:mainViewController animated:YES completion:nil];
            }
            else {
                NSLog(@"Save authenticator failed.");
            }
        }
        else {
            NSLog(@"No Serial or Restore Code for Restoring.");
        }
    }
    else if (processingType == ProcessingTypeFixInconsistency) {
        //Fix Inconsistency
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate setGAuthenticator:[processingParameters objectForKey:kFixInconsistencyAuthenticatorKey]];
        
        if ([[processingParameters objectForKey:kFixInconsistencySaveCloudKey] boolValue]) {
            [AuthenticatorOperation saveToCloud:appDelegate.gAuthenticator];
        }
        else {
            NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
            [AuthenticatorOperation save:appDelegate.gAuthenticator toFile:filePath];
        }
        
        [self presentViewController:[self.storyboard instantiateInitialViewController] animated:YES completion:nil];
    }
    else {
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex == buttonIndex) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [ai_Processing startAnimating];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(completeProcess) userInfo:nil repeats:NO];
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
