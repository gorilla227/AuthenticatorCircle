//
//  ResetAuthenticator.m
//  AuthenticatorCircle
//
//  Created by Andy on 15/8/23.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "ResetAuthenticator.h"
#import "ProcessingViewController.h"

@interface ResetAuthenticator ()
@property (nonatomic, strong) IBOutlet UIImageView *iv_WarningSign;
@property (nonatomic, strong) IBOutlet UILabel *lb_Question;
@property (nonatomic, strong) IBOutlet UILabel *lb_Warning;
@property (nonatomic, strong) IBOutlet UIButton *btn_GoBack;
@property (nonatomic, strong) IBOutlet UIButton *btn_ResetMyAuthenticator;
@end

@implementation ResetAuthenticator {
    NSDictionary *uiStrings;
}
@synthesize iv_WarningSign, lb_Question, lb_Warning, btn_GoBack, btn_ResetMyAuthenticator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    uiStrings = [gUIStrings objectForKey:@"UI_ResetAuthenticator"];
    [UIView animateWithDuration:1.5f delay:0.0f options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [iv_WarningSign setTransform:CGAffineTransformMakeScale(1.05f, 1.05f)];
    } completion:nil];
    [btn_ResetMyAuthenticator.layer setBorderColor:[UIColor grayColor].CGColor];
    [btn_ResetMyAuthenticator.layer setBorderWidth:1.0f];
    [btn_ResetMyAuthenticator.layer setCornerRadius:kButtonCornerRadius];
    [btn_ResetMyAuthenticator.layer setMasksToBounds:YES];
    [btn_GoBack.layer setCornerRadius:kButtonCornerRadius];
    [btn_GoBack.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [lb_Warning sizeToFit];
}

- (IBAction)btn_GoBack_OnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_ResetMyAuthenticator_OnClicked:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[uiStrings objectForKey:@"UI_RA_Reset_Message"] delegate:self cancelButtonTitle:[uiStrings objectForKey:@"UI_RA_Reset_Cancel"] otherButtonTitles:[uiStrings objectForKey:@"UI_RA_Reset_Reset"], nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [self performSegueWithIdentifier:@"ResetMyAuthenticator" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ResetMyAuthenticator"]) {
        ProcessingViewController *process = segue.destinationViewController;
        [process setProcessingType:ProcessingTypeResetting];
    }
}

@end
