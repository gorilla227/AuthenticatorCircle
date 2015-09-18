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
@property (nonatomic, strong) IBOutlet UILabel *lb_Copied;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *lb_Sync;
@end

@implementation ShowAuthenticator {
    ArcProgressView *progressView;
    UIImageView *backgroundImageView;
    NSMutableArray *bgImages;
    UIImage *currentBackgroundImage;
    NSDictionary *uiStrings;
    AuthenticatorSimulator *authenticatorSimulator;
}
@synthesize progressViewContainer, lb_Passcode, btn_Copy, lb_Copied, lb_Sync;

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
    
    //Initial lb_Sync
    [lb_Sync setLinkAttributes:@{(id)kCTForegroundColorAttributeName:(id)self.view.tintColor.CGColor,
                                        NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)}];
    [lb_Sync setActiveLinkAttributes:@{(id)kCTForegroundColorAttributeName:(id)[UIColor grayColor].CGColor}];
    [self configSyncLabel:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!progressView) {
        progressView = [[ArcProgressView alloc] initWithDiameter:progressViewContainer.bounds.size.width arcWidth:10.0f arcRadian:360.0f];
        [progressView showOrHiddenProgressLabel:NO countDownLabel:YES];
        [progressViewContainer insertSubview:progressView atIndex:0];
        
        [authenticatorSimulator hookupPasscodeLabel:lb_Passcode arcProgressView:progressView];
        [authenticatorSimulator startTimerFrom:(float)(arc4random() % 100) / 100];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setTransform:CGAffineTransformMakeScale(1, 1)];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setTransform:CGAffineTransformMakeScale(0.95, 0.95)];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)configSyncLabel:(NSInteger)tag {
    NSString *prefixText;
    NSString *linkText;
    NSRange linkRange;
    
    [lb_Sync setTag:tag];
    switch (tag) {
        case 0://Click to Resync
            prefixText = [uiStrings objectForKey:@"UI_SA_Resync_NotWorking"];
            linkText = [uiStrings objectForKey:@"UI_SA_Resync_TryResyncing"];
            [lb_Sync setText:[NSString stringWithFormat:@"%@ %@", prefixText, linkText]];
            linkRange = [lb_Sync.text rangeOfString:linkText];
            [lb_Sync addLinkToURL:nil withRange:linkRange];
            break;
        case 1://Resyncing
            [lb_Sync setText:[uiStrings objectForKey:@"UI_SA_Resync_Resyncing"]];
            break;
        case 2://Still not working
            prefixText = [uiStrings objectForKey:@"UI_SA_Resync_SyncComplete"];
            linkText = [uiStrings objectForKey:@"UI_SA_Resync_StillNotWorking"];
            [lb_Sync setText:[NSString stringWithFormat:@"%@ %@", prefixText, linkText]];
            linkRange = [lb_Sync.text rangeOfString:linkText];
            [lb_Sync addLinkToURL:nil withRange:linkRange];
            break;
        default:
            break;
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if (lb_Sync.tag == 0) {
        //Resync
        [self configSyncLabel:1];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(syncAuthenticator) userInfo:nil repeats:NO];
    }
    else if (lb_Sync.tag == 2) {
        //Show help content
        HelpContent *helpContent = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpContent"];
        [helpContent setHelpDetail:[[gUIStrings objectForKey:@"HelpList"] lastObject]];
        [helpContent.navigationController setNavigationBarHidden:NO];
        [helpContent.navigationItem setRightBarButtonItem:helpContent.btn_Close];
        UINavigationController *helpNavi = [[UINavigationController alloc] initWithRootViewController:helpContent];
        [helpNavi.navigationBar setBarTintColor:cMenuTintColor];
        
        [self presentViewController:helpNavi animated:YES completion:nil];
    }
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

- (void)syncAuthenticator {
    [self configSyncLabel:2];
    [authenticatorSimulator sync];
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
