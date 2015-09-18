//
//  RestoreWithRestoreCode.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/9/3.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "RestoreWithRestoreCode.h"

@interface RestoreWithRestoreCode ()
@property (nonatomic, strong) IBOutlet UILabel *lb_Description;
@property (nonatomic, strong) IBOutlet UITextField *tf_Serial;
@property (nonatomic, strong) IBOutlet UITextField *tf_RestoreCode;
@property (nonatomic, strong) IBOutlet UIButton *btn_Submit;
@end

@implementation RestoreWithRestoreCode {
    UISegmentedControl *sc_RegionCodes;
    NSArray *regionCodes;
    NSDictionary *uiStrings;
}
@synthesize lb_Description, tf_Serial, tf_RestoreCode, btn_Submit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    uiStrings = [gUIStrings objectForKey:@"UI_RestoreWithRestoreCode"];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppBackground.jpg"]]];
    
    [btn_Submit updateUIButtonStyle:UIButtonStyleLightBlue];
    [tf_Serial setBackgroundColor:cTextFieldBackground];
    [tf_RestoreCode setBackgroundColor:cTextFieldBackground];
    
    //Set Region Selection
    regionCodes = [gUIStrings objectForKey:@"SerialRegionCodes"];
    sc_RegionCodes = [[UISegmentedControl alloc] initWithItems:regionCodes];
    [sc_RegionCodes setBackgroundColor:cBackground];
    [sc_RegionCodes setTintColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
    [sc_RegionCodes addTarget:self action:@selector(sc_RegionCodes_Changed:) forControlEvents:UIControlEventValueChanged];
    
    [tf_Serial setInputAccessoryView:sc_RegionCodes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_Submit_OnClicked:(id)sender {
    if (tf_Serial.text.length == 17 && tf_RestoreCode.text.length == 10) {
        [self performSegueWithIdentifier:@"RestoreWithCode" sender:self];        
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[uiStrings objectForKey:@"UI_RWRC_NotComplete_AlertViewMessage"] delegate:nil cancelButtonTitle:[uiStrings objectForKey:@"UI_RWRC_NotComplete_AlertViewCancel"] otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)sc_RegionCodes_Changed:(id)sender {
    if (sc_RegionCodes.selectedSegmentIndex >= 0) {
        NSString *selectedRegion = [regionCodes objectAtIndex:sc_RegionCodes.selectedSegmentIndex];
        if (tf_Serial.text.length >= 3) {
            NSMutableString *serialNumber = [NSMutableString stringWithString:tf_Serial.text];
            [serialNumber replaceCharactersInRange:NSMakeRange(0, 2) withString:selectedRegion];
            [tf_Serial setText:serialNumber];
        }
        else {
            [tf_Serial setText:[NSString stringWithFormat:@"%@-", selectedRegion]];
        }
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [tf_Serial resignFirstResponder];
    [tf_RestoreCode resignFirstResponder];
}

#pragma TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:tf_Serial]) {
        if ([string isEqualToString:@"."]) {
            return NO;
        }
        NSString *potentialString = [tf_Serial.text stringByReplacingCharactersInRange:range withString:string];
        if (potentialString.length < 3 || potentialString.length >= 18) {
            return NO;
        }
        if (potentialString.length == 8 || potentialString.length == 13) {
            if (tf_Serial.text.length == 7 || tf_Serial.text.length == 12) {
                [tf_Serial setText:[tf_Serial.text stringByPaddingToLength:potentialString.length withString:@"-" startingAtIndex:0]];
            }
            else {
                [tf_Serial setText:[tf_Serial.text stringByPaddingToLength:potentialString.length - 1 withString:@"" startingAtIndex:0]];
                return NO;
            }
        }
//        [btn_Submit setEnabled:potentialString.length == 17 && tf_RestoreCode.text.length == 10];
    }
    else if ([textField isEqual:tf_RestoreCode]) {
        if ((![string isEqualToString:@""] && ![[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[string characterAtIndex:0]]) || ([tf_RestoreCode.text stringByReplacingCharactersInRange:range withString:string].length > 10)) {
            return NO;
        }
//        [btn_Submit setEnabled:[tf_RestoreCode.text stringByReplacingCharactersInRange:range withString:string].length == 10 && tf_Serial.text.length == 17];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:tf_RestoreCode]) {
        [self btn_Submit_OnClicked:btn_Submit];
    }
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"RestoreWithCode"]) {
        ProcessingViewController *process = segue.destinationViewController;
        [process setProcessingType:ProcessingTypeRestoreWithCode];
        [process setProcessingParameters:@{kSerialKey:tf_Serial.text, kRestoreCodeKey:tf_RestoreCode.text}];
    }
}

@end
