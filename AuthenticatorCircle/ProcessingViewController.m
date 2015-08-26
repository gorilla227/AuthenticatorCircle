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
@synthesize lb_Processing, ai_Processing, processingType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    uiStrings = [gUIStrings objectForKey:@"UI_Processing"];
    [self.view.layer setContents:(id)[UIImage imageNamed:@"AppBackground.jpg"].CGImage];
    [self.view setContentMode:UIViewContentModeScaleAspectFill];
    switch (processingType) {
        case ProcessingTypeResetting:
            [lb_Processing setText:[uiStrings objectForKey:@"UI_Processing_Resetting"]];
            break;
        case ProcessingTypeSettingUp:
            [lb_Processing setText:[uiStrings objectForKey:@"UI_Processing_SettingUp"]];
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
        AppDelegate *appDeldgate = [[UIApplication sharedApplication] delegate];
        [appDeldgate setGAuthenticator:nil];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];

        UIViewController *initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
        [self presentViewController:initialViewController animated:YES completion:nil];
    }
    else if (processingType == ProcessingTypeSettingUp) {
        AuthenticatorSimulator *newAuthenticator = [[AuthenticatorSimulator alloc] initWithSeriesNumber:@"CN" andRestoreCode:nil];
        NSData *authenticatorData = [NSKeyedArchiver archivedDataWithRootObject:newAuthenticator];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
        [NSKeyedArchiver archiveRootObject:newAuthenticator toFile:filePath];
        KeychainWrapper *keychainItem = [[KeychainWrapper alloc] initWithNewKeychain:@{(__bridge id)kSecAttrAccount:kKeychainAccount,
                                                                                       (__bridge id)kSecAttrService:kKeychainService,
                                                                                       (__bridge id)kSecAttrGeneric:[kKeychainIdentifier dataUsingEncoding:NSUTF8StringEncoding],
                                                                                       (__bridge id)kSecValueData:authenticatorData}];
        if (keychainItem.keychainData) {
            AppDelegate *appDeldgate = [[UIApplication sharedApplication] delegate];
            [appDeldgate setGAuthenticator:newAuthenticator];
            UIViewController *setUpAuthenticator = [self.storyboard instantiateViewControllerWithIdentifier:@"SetUpAuthenticator"];
            [self presentViewController:setUpAuthenticator animated:YES completion:nil];
        }
    }
    else {
        
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
