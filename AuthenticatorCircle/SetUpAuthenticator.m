//
//  SetUpAuthenticator.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/8/25.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "SetUpAuthenticator.h"

@interface SetUpAuthenticator ()
@property (nonatomic, strong) IBOutlet UILabel *lb_SerialNumber;
@property (nonatomic, strong) IBOutlet UILabel *lb_AuthenticatorCode;
@property (nonatomic, strong) IBOutlet UIProgressView *pv_ProgressView;
@property (nonatomic, strong) IBOutlet UIButton *btn_Continue;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *lb_Instuction;
@end

@implementation SetUpAuthenticator {
    AuthenticatorSimulator *authenticator;
    NSDictionary *uiStrings;
}
@synthesize lb_SerialNumber, lb_AuthenticatorCode, pv_ProgressView, btn_Continue, lb_Instuction;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Initial Authenticator
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    authenticator = appDelegate.gAuthenticator;
    [authenticator hookupPasscodeLabel:lb_AuthenticatorCode progressView:pv_ProgressView];
    [authenticator sync];
    
    //Set UI Appearance
    [self.view setBackgroundColor:cViewBackground];
    [self.navigationController setNavigationBarHidden:YES];
    [lb_SerialNumber setText:[authenticator retrieveSeriesNumber]];
    [btn_Continue updateUIButtonStyle:UIButtonStyleLightBlue];
    [lb_AuthenticatorCode setText:nil];
    [pv_ProgressView setTransform:CGAffineTransformMakeScale(1, 2)];
    [pv_ProgressView.layer setCornerRadius:1.0f];
    [pv_ProgressView.layer setMasksToBounds:YES];
    
    //Set URL link in Instruction
    uiStrings = [gUIStrings objectForKey:@"UI_SetUpAuthenticator"];
    [lb_Instuction setLinkAttributes:@{(id)kCTForegroundColorAttributeName:(id)self.view.tintColor.CGColor,
                                       NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)}];
    [lb_Instuction setActiveLinkAttributes:@{(id)kCTForegroundColorAttributeName:(id)[UIColor grayColor].CGColor}];
    
    NSString *linkText = [uiStrings objectForKey:@"UI_SUA_BMA_LinkText"];
    NSString *instructionString = [NSString stringWithFormat:[uiStrings objectForKey:@"UI_SUA_Instruction"], linkText];
    NSRange linkRange = [instructionString rangeOfString:linkText];
    [lb_Instuction setText:instructionString];
    [lb_Instuction addLinkToURL:[NSURL URLWithString:[uiStrings objectForKey:@"UI_SUA_BMA_LinkURL"]] withRange:linkRange];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    BOOL result = [[UIApplication sharedApplication] openURL:url];
    NSLog(@"BMA_Link:%@",result?@"YES":@"NO");
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
