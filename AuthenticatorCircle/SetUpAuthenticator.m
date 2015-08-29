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
@property (nonatomic, strong) IBOutlet UIButton *btn_BMALink;
@property (nonatomic, strong) IBOutlet UIButton *btn_Continue;
@property (nonatomic, strong) IBOutlet UITextView *tv_Instuction;
@end

@implementation SetUpAuthenticator {
    AuthenticatorSimulator *authenticator;
    NSDictionary *uiStrings;
}
@synthesize lb_SerialNumber, lb_AuthenticatorCode, pv_ProgressView, btn_BMALink, btn_Continue, tv_Instuction;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Initial Authenticator
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    authenticator = appDelegate.gAuthenticator;
    [authenticator hookupPasscodeLabel:lb_AuthenticatorCode progressView:pv_ProgressView];
    [authenticator sync];
    
    //Set UI Appearance
    [self.view.layer setContents:(id)[UIImage imageNamed:@"AppBackground.jpg"].CGImage];
    [self.view setContentMode:UIViewContentModeScaleAspectFill];
    [lb_SerialNumber setText:[authenticator retrieveSeriesNumber]];
    [btn_Continue.layer setCornerRadius:3.0f];
    [btn_Continue.layer setMasksToBounds:YES];
    [lb_AuthenticatorCode setText:nil];
    [pv_ProgressView setTransform:CGAffineTransformMakeScale(1, 2)];
    [pv_ProgressView.layer setCornerRadius:1.0f];
    [pv_ProgressView.layer setMasksToBounds:YES];
    
    //Set URL link in Instruction
    uiStrings = [gUIStrings objectForKey:@"UI_SetUpAuthenticator"];
    NSString *linkText = [uiStrings objectForKey:@"UI_SUA_BMA_LinkText"];    NSMutableAttributedString *instructionString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:[uiStrings objectForKey:@"UI_SUA_Instruction"], linkText]];
    [instructionString addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                       NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} range:NSMakeRange(0, instructionString.length)];
    [instructionString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[instructionString.string rangeOfString:linkText]];
    
    [tv_Instuction setAttributedText:instructionString];
    [tv_Instuction sizeToFit];
    [tv_Instuction.layoutManager ensureLayoutForTextContainer:tv_Instuction.textContainer];
    NSRange range = [instructionString.string rangeOfString:linkText];
    UITextPosition *start = [tv_Instuction positionFromPosition:tv_Instuction.beginningOfDocument offset:range.location];
    UITextPosition *end = [tv_Instuction positionFromPosition:start offset:range.length];
    UITextRange *textRange = [tv_Instuction textRangeFromPosition:start toPosition:end];
    CGRect linkRect = [tv_Instuction firstRectForRange:textRange];
    
    [btn_BMALink setFrame:linkRect];
    [tv_Instuction addSubview:btn_BMALink];
    [tv_Instuction setEditable:NO];
    [tv_Instuction setSelectable:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)btn_Continue_OnClicked:(id)sender {
    
}

- (IBAction)btn_BMALink_OnClicked:(id)sender {    
    NSURL *url = [NSURL URLWithString:[uiStrings objectForKey:@"UI_SUA_BMA_LinkURL"]];
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
