//
//  ShowAuthenticator.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/8/12.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//
extern AuthenticatorSimulator *gAuthenticator;
#import "ShowAuthenticator.h"
#import "ArcProgressView.h"
#import "HelpContent.h"

@interface ShowAuthenticator ()
@property (nonatomic, strong) IBOutlet UIView *progressViewContainer;
@property (nonatomic, strong) IBOutlet UILabel *lb_Passcode;
@property (nonatomic, strong) IBOutlet UIButton *btn_Copy;
@property (nonatomic, strong) IBOutlet UILabel *lb_Sync;
@property (nonatomic, strong) IBOutlet UIButton *btn_Sync;
@property (nonatomic, strong) IBOutlet UIView *view_Sync;
@property (nonatomic, strong) IBOutlet UILabel *lb_Copied;
@end

@implementation ShowAuthenticator {
    ArcProgressView *progressView;
    UIImageView *backgroundImageView;
    NSMutableArray *bgImages;
    UIImage *currentBackgroundImage;
    NSDictionary *uiStrings;
    AuthenticatorSimulator *authenticatorSimulator;
}
@synthesize progressViewContainer, lb_Passcode, btn_Copy, lb_Sync, btn_Sync, view_Sync, lb_Copied;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    authenticatorSimulator = appDelegate.gAuthenticator;
    
    [progressViewContainer setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    uiStrings = [gUIStrings objectForKey:@"UI_ShowAuthenticator"];
    
    //Set BackgroundImageView and gradient layer
    backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    CAGradientLayer *backgroundImageViewGradientLayer =[CAGradientLayer layer];
    [backgroundImageViewGradientLayer setColors:@[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor]];
    [backgroundImageViewGradientLayer setFrame:backgroundImageView.bounds];
    [backgroundImageView.layer addSublayer:backgroundImageViewGradientLayer];
    [backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view insertSubview:backgroundImageView atIndex:0];
    [self.view.layer setMasksToBounds:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBackgroundImage:) name:kRepeatNotification object:nil];
    
    //Load bgImages
    bgImages = [NSMutableArray new];
    NSArray *imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil];
    for (NSString *imagePath in imagePaths) {
        if ([imagePath.lastPathComponent hasPrefix:@"BG_"]) {
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            [bgImages addObject:image];
        }
    }
    currentBackgroundImage = bgImages.firstObject;
    [backgroundImageView setImage:currentBackgroundImage];
    [bgImages removeObject:currentBackgroundImage];
    
    //Initial lb_Copied
    [lb_Copied setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
    [lb_Copied setAlpha:0];
    [lb_Copied setTransform:CGAffineTransformMakeTranslation(0, -lb_Copied.bounds.size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    if (!progressView) {
        progressView = [[ArcProgressView alloc] initWithDiameter:progressViewContainer.bounds.size.width arcWidth:10.0f arcRadian:360.0f];
        [progressView showOrHiddenProgressLabel:NO countDownLabel:YES];
        [progressViewContainer insertSubview:progressView atIndex:0];
        
        [authenticatorSimulator hookupPasscodeLabel:lb_Passcode arcProgressView:progressView];
        [authenticatorSimulator startTimerFrom:(float)(arc4random() % 100) / 100];
    }
    
    //Config sync text
    switch (btn_Sync.tag) {
        case 0:
            [self configSyncText:[uiStrings objectForKey:@"UI_SA_Resync_NotWorking"] buttonText:[uiStrings objectForKey:@"UI_SA_Resync_TryResyncing"]];
            break;
        case 1:
            [self configSyncText:[uiStrings objectForKey:@"UI_SA_Resync_Resyncing"] buttonText:nil];
            break;
        case 2:
            [self configSyncText:[uiStrings objectForKey:@"UI_SA_Resync_SyncComplete"] buttonText:[uiStrings objectForKey:@"UI_SA_Resync_StillNotWorking"]];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setTransform:CGAffineTransformMakeScale(1, 1)];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setTransform:CGAffineTransformMakeScale(0.95, 0.95)];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)configSyncText:(NSString *)labelText buttonText:(NSString *)buttonText {
    [lb_Sync setText:labelText];
    [btn_Sync setTitle:buttonText forState:UIControlStateNormal];
    [lb_Sync sizeToFit];
    [btn_Sync sizeToFit];
    CGRect containFrame = CGRectUnion(lb_Sync.frame, btn_Sync.frame);
    CGPoint center = CGPointMake(self.view.center.x, self.view.bounds.size.height - containFrame.size.height);
    [view_Sync setFrame:containFrame];
    [view_Sync setCenter:center];
}

- (void)changeBackgroundImage:(NSNotification *)notification {
    UIImage *previousBackgroundImage = currentBackgroundImage;
    currentBackgroundImage = [bgImages objectAtIndex:(arc4random() % bgImages.count)];
    [UIView transitionWithView:backgroundImageView duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [backgroundImageView setImage:currentBackgroundImage];
    } completion:NULL];
    [bgImages addObject:previousBackgroundImage];
    [bgImages removeObject:currentBackgroundImage];
}

- (IBAction)btn_Copy_OnClicked:(id)sender {
    [[UIPasteboard generalPasteboard] setString:lb_Passcode.text];
//    UIAlertView *copySucc = [[UIAlertView alloc] initWithTitle:nil message:@"Passcode is copied to clipboard successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [copySucc show];
    [btn_Copy setEnabled:NO];
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [lb_Copied setAlpha:1.0f];
        [lb_Copied setTransform:CGAffineTransformMakeTranslation(0, 0)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [lb_Copied setAlpha:0.0f];
            [lb_Copied setTransform:CGAffineTransformMakeTranslation(0, -lb_Copied.bounds.size.height)];
        } completion:^(BOOL finished) {
            [btn_Copy setEnabled:YES];
        }];
    }];
}
- (IBAction)btn_Sync_OnClicked:(id)sender {
    if (btn_Sync.tag == 0) {
        [btn_Sync setTag:1];
        [self configSyncText:[uiStrings objectForKey:@"UI_SA_Resync_Resyncing"] buttonText:nil];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(syncAuthenticator) userInfo:nil repeats:NO];
    }
    else {
        HelpContent *helpContent = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpContent"];
        [helpContent setHelpDetail:[[gUIStrings objectForKey:@"HelpList"] lastObject]];
        [helpContent.navigationController setNavigationBarHidden:NO];
        [helpContent.navigationItem setRightBarButtonItem:helpContent.btn_Close];
        UINavigationController *helpNavi = [[UINavigationController alloc] initWithRootViewController:helpContent];
        [helpNavi.navigationBar setBarTintColor:cMenuTintColor];

        [self presentViewController:helpNavi animated:YES completion:nil];
    }
}

- (void)syncAuthenticator {
    [btn_Sync setTag:2];
    [authenticatorSimulator sync];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AdditionalHelp"]) {        
        HelpContent *helpContent = segue.destinationViewController;
        [helpContent setHelpDetail:[[gUIStrings objectForKey:@"HelpList"] lastObject]];
        [helpContent.navigationController setNavigationBarHidden:NO];
    }
}

@end
