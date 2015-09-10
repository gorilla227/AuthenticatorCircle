//
//  RestoreAuthenticator.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/9/3.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "RestoreAuthenticator.h"

@interface RestoreAuthenticator ()
@property (nonatomic, strong) IBOutlet UILabel *lb_Description;
@property (nonatomic, strong) IBOutlet UIButton *btn_RestoreFromICloudKeychain;
@property (nonatomic, strong) IBOutlet UIButton *btn_UseRestoreCode;
@end

@implementation RestoreAuthenticator
@synthesize lb_Description, btn_RestoreFromICloudKeychain, btn_UseRestoreCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:cViewBackground];
    
    [btn_RestoreFromICloudKeychain.layer setCornerRadius:kButtonCornerRadius];
    [btn_RestoreFromICloudKeychain.layer setMasksToBounds:YES];
    [btn_UseRestoreCode.layer setCornerRadius:kButtonCornerRadius];
    [btn_UseRestoreCode.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"RestoreKeychain"]) {
        ProcessingViewController *process = segue.destinationViewController;
        [process setProcessingType:ProcessingTypeRestoreKeychain];
    }
}

@end
