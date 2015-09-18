//
//  UIButton+StyleButton.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/9/17.
//  Copyright © 2015年 Andy Xu. All rights reserved.
//

#import "UIButton+StyleButton.h"

@implementation UIButton (StyleButton)
- (void)updateUIButtonStyle:(UIButtonStyle)style {
    switch (style) {
        case UIButtonStyleLightBlue:
            [self.layer setMasksToBounds:YES];
            [self.layer setCornerRadius:kButtonCornerRadius];
            [self.layer setBorderWidth:0];
            [self setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0f]];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case UIButtonStyleDarkBlue1:
            [self.layer setMasksToBounds:YES];
            [self.layer setCornerRadius:kButtonCornerRadius];
            [self.layer setBorderColor:[UIColor grayColor].CGColor];
            [self.layer setBorderWidth:1.0f];
            [self setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:51/255.0 alpha:1.0f]];
            [self setTitleColor:[UIColor colorWithRed:27.0/255.0 green:127.0/255.0 blue:252.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
            break;
        case UIButtonStyleDarkBlue2:
            [self.layer setMasksToBounds:YES];
            [self.layer setCornerRadius:kButtonCornerRadius];
            [self.layer setBorderColor:[UIColor grayColor].CGColor];
            [self.layer setBorderWidth:1.0f];
            [self setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:51/255.0 alpha:1.0f]];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
@end
