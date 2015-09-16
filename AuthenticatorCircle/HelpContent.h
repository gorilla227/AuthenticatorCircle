//
//  HelpContent.h
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/9/11.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpContent : UIViewController <TTTAttributedLabelDelegate>
@property (nonatomic) NSDictionary *helpDetail;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *btn_Close;
@end
