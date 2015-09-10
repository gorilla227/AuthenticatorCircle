//
//  Menu.m
//  AuthenticatorCircle
//
//  Created by Andy on 15/8/15.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

@import MessageUI;
#import "Menu.h"

@interface Menu ()
@property (nonatomic, strong) IBOutlet UILabel *lb_CopyRights;
@end

@implementation Menu {
    BOOL isCopyRightFrameSet;
}
@synthesize lb_CopyRights;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:54.0/255.0 green:61.0/255.0 blue:78.0/255.0 alpha:1.0f]];
    [self.tableView setBackgroundColor:cBackground];
    [lb_CopyRights setBackgroundColor:cBackground];
    [lb_CopyRights sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_Done_OnClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLayoutSubviews {
    if (!isCopyRightFrameSet) {
        CGRect copyRightsFrame = lb_CopyRights.frame;
        copyRightsFrame.origin.y = self.tableView.bounds.size.height - self.tableView.contentSize.height + lb_CopyRights.frame.origin.y - (108.0f - copyRightsFrame.size.height);
        copyRightsFrame.size.height = 108.0f;
        [lb_CopyRights setFrame:copyRightsFrame];
        isCopyRightFrameSet = YES;
    }
}

- (IBAction)clear:(id)sender {
    [KeychainWrapper clearKeychains:kKeychainIdentifier];
    [[NSFileManager defaultManager] removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile] error:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"SendFeedback"]) {
        if ([MFMailComposeViewController canSendMail]) {
            NSDictionary *feedbackMailComponents = [gUIStrings objectForKey:@"FeedbackMailComponents"];
            MFMailComposeViewController *compose = [[MFMailComposeViewController alloc] init];
            [compose setMailComposeDelegate:self];
            [compose.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
            [compose.navigationBar setTintColor:self.view.tintColor];
            [compose setSubject:[feedbackMailComponents objectForKey:@"Subject"]];
            [compose setToRecipients:@[[feedbackMailComponents objectForKey:@"To"]]];
            
            NSString *warningMessage = [feedbackMailComponents objectForKey:@"WarningMessage"];
            NSString *appVersion = [NSString stringWithFormat:[feedbackMailComponents objectForKey:@"AppVersion"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            NSString *locale = [NSString stringWithFormat:[feedbackMailComponents objectForKey:@"Locale"], [[NSBundle mainBundle] preferredLocalizations].firstObject];
            NSString *device = [NSString stringWithFormat:[feedbackMailComponents objectForKey:@"Device"], [UIDevice currentDevice].model];
            NSString *iosVersion = [NSString stringWithFormat:[feedbackMailComponents objectForKey:@"IOSVersion"], [UIDevice currentDevice].systemVersion];
            NSString *sentFrom =  [NSString stringWithFormat:[feedbackMailComponents objectForKey:@"SentFrom"], [UIDevice currentDevice].model];
            NSString *body = [NSString stringWithFormat:[feedbackMailComponents objectForKey:@"Body"], warningMessage, appVersion, locale, device, iosVersion, sentFrom];
            [compose setMessageBody:body isHTML:YES];
            
            [self presentViewController:compose animated:YES completion:nil];
        }
        else {
            NSLog(@"This device cannot send email.");
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failed.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Draft saved.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent.");
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
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
