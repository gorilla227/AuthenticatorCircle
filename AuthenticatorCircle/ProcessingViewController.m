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

@implementation ProcessingViewController {
    NSDictionary *uiStrings;
}
@synthesize lb_Processing, ai_Processing, processingType, processingParameters;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    uiStrings = [gUIStrings objectForKey:@"UI_Processing"];
    [self.view setBackgroundColor:cViewBackground];
    [self.navigationController setNavigationBarHidden:YES];
    switch (processingType) {
        case ProcessingTypeResetting:
            [lb_Processing setText:[uiStrings objectForKey:@"UI_Processing_Resetting"]];
            break;
        case ProcessingTypeSettingUp:
            [lb_Processing setText:[uiStrings objectForKey:@"UI_Processing_SettingUp"]];
            break;
        case ProcessingTypeRestoreWithCode:
        case ProcessingTypeRestoreKeychain:
            [lb_Processing setText:[uiStrings objectForKey:@"UI_Processing_Restore"]];
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
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];

        UIViewController *initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialNavi"];
        [self presentViewController:initialViewController animated:YES completion:nil];
    }
    else if (processingType == ProcessingTypeSettingUp) {
        //Set up new Authenticator
        AuthenticatorSimulator *newAuthenticator = [[AuthenticatorSimulator alloc] initWithSeriesNumber:@"CN" andRestoreCode:nil];
        
        if ([self saveAuthenticatorLocalAndICloud:newAuthenticator]) {
            [self performSegueWithIdentifier:@"SetUpNewAuthenticator" sender:nil];
        }
    }
    else if (processingType == ProcessingTypeRestoreKeychain) {
        //Restore from iCloud
        NSArray *existedKeychains = [KeychainWrapper retriveKeychainsByAttributes:kKeychainIdentifier];
        for (NSDictionary *keychainAttribute in existedKeychains) {
            if ([[keychainAttribute objectForKey:(__bridge id)kSecAttrAccount] isEqual:kKeychainAccount] && [[keychainAttribute objectForKey:(__bridge id)kSecAttrService] isEqual:kKeychainService]) {
                //Authenticator Existed
                KeychainWrapper *keychainItem = [[KeychainWrapper alloc] initWithAttributes:keychainAttribute];
                AuthenticatorSimulator *authenticator = [NSKeyedUnarchiver unarchiveObjectWithData:keychainItem.keychainData];
                if (authenticator) {
                    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
                    [NSKeyedArchiver archiveRootObject:authenticator toFile:filePath];
                    
                    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                    [appDelegate setGAuthenticator:authenticator];
                    
                    [self performSegueWithIdentifier:@"RestoreKeychainDone" sender:self];
                }
                break;
            }
        }
    }
    else if (processingType == ProcessingTypeRestoreWithCode) {
        //Restore with Serial & RestoreCode
        if ([processingParameters.allKeys containsObject:kSerialKey] && [processingParameters.allKeys containsObject:kRestoreCodeKey]) {
            AuthenticatorSimulator *authenticator = [[AuthenticatorSimulator alloc] initWithSeriesNumber:[processingParameters objectForKey:kSerialKey] andRestoreCode:[processingParameters objectForKey:kRestoreCodeKey]];
            if ([self saveAuthenticatorLocalAndICloud:authenticator]) {
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
    else {
        
    }
}

- (BOOL)saveAuthenticatorLocalAndICloud:(AuthenticatorSimulator *)authenticator {
    if (authenticator) {
        NSData *authenticatorData = [NSKeyedArchiver archivedDataWithRootObject:authenticator];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
        [NSKeyedArchiver archiveRootObject:authenticator toFile:filePath];
        NSArray *existedKeychains = [KeychainWrapper retriveKeychainsByAttributes:kKeychainIdentifier];
        for (NSDictionary *keychainAttribute in existedKeychains) {
            if ([[keychainAttribute objectForKey:(__bridge id)kSecAttrAccount] isEqual:kKeychainAccount] && [[keychainAttribute objectForKey:(__bridge id)kSecAttrService] isEqual:kKeychainService]) {
                //Authenticator Existed
                KeychainWrapper *keychainItem = [[KeychainWrapper alloc] initWithAttributes:keychainAttribute];
                [keychainItem deleteKeychain];
                break;
            }
        }
        
        KeychainWrapper *keychainItem = [[KeychainWrapper alloc] initWithNewKeychain:@{(__bridge id)kSecAttrAccount:kKeychainAccount,
                                                                                       (__bridge id)kSecAttrService:kKeychainService,
                                                                                       (__bridge id)kSecAttrGeneric:[kKeychainIdentifier dataUsingEncoding:NSUTF8StringEncoding],
                                                                                       (__bridge id)kSecValueData:authenticatorData}];
        BOOL result = keychainItem.keychainData;
        if (result) {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate setGAuthenticator:authenticator];
        }
        return result;
    }
    else {
        NSLog(@"Authenticator is NULL.");
        return NO;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

@end
