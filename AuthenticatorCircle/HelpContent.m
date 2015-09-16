//
//  HelpContent.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/9/11.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "HelpContent.h"

@interface HelpContent ()
@property (nonatomic, strong) IBOutlet UILabel *lb_HelpTitle;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *lb_HelpContent;
@end

@implementation HelpContent
@synthesize helpDetail, lb_HelpContent, lb_HelpTitle, btn_Close;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Set TTTAttributedLabel Link Attributes
    [lb_HelpContent setLinkAttributes:@{(id)kCTForegroundColorAttributeName:(id)self.view.tintColor.CGColor,
                                       NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)}];
    [lb_HelpContent setActiveLinkAttributes:@{(id)kCTForegroundColorAttributeName:(id)[UIColor grayColor].CGColor}];
    
    if (helpDetail) {
        //Set Help Title
        [lb_HelpTitle setText:[helpDetail objectForKey:@"HelpTitle"]];
        
        //Set Help Content
        NSArray *links = [helpDetail objectForKey:@"Links"];
        if (links && links.count) {
            //Have links
            NSArray *helpContentArray = [[helpDetail objectForKey:@"HelpContent"] componentsSeparatedByString:kLinkSeperator];
            if (helpContentArray.count / 2 <= links.count) {
                NSString *finalString = [NSString new];
                NSMutableDictionary *linksDictionary = [NSMutableDictionary new];
                for (int i = 0; i < helpContentArray.count; i++) {
                    NSString *helpContentComponent = [helpContentArray objectAtIndex:i];
                    finalString = [finalString stringByAppendingString:helpContentComponent];
                    if (i % 2) {
                        NSRange linkRange = [finalString rangeOfString:helpContentComponent];
                        NSURL *linkURL = [NSURL URLWithString:[links objectAtIndex:i/2]];
                        [linksDictionary setObject:linkURL forKey:[NSValue valueWithRange:linkRange]];
                    }
                }
                [lb_HelpContent setText:finalString];
                for (NSValue *value in linksDictionary.allKeys) {
                    NSRange range = value.rangeValue;
                    NSURL *url = [linksDictionary objectForKey:value];
                    [lb_HelpContent addLinkToURL:url withRange:range];
                }
            }
            else {
                //Don't have enough links for token in HelpContent.
                [lb_HelpContent setText:[helpDetail objectForKey:@"HelpContent"]];
                NSLog(@"Don't have enough links for token in HelpContent.");
            }
        }
        else {
            //No links
            [lb_HelpContent setText:[helpDetail objectForKey:@"HelpContent"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    BOOL result = [[UIApplication sharedApplication] openURL:url];
    NSLog(@"Open Link: %@",result?@"Successed":@"Failed");
}

- (IBAction)btn_Close_OnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
