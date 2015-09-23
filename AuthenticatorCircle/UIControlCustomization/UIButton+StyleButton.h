//
//  UIButton+StyleButton.h
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/9/17.
//  Copyright © 2015年 Andy Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, UIButtonStyle) {
    UIButtonStyleDefault,
    UIButtonStyleLightBlue,
    UIButtonStyleDarkBlue1,
    UIButtonStyleDarkBlue2
};

@interface UIButton (StyleButton)
- (void)updateUIButtonStyle:(UIButtonStyle)style;
@end
