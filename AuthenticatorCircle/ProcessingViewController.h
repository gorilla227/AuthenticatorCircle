//
//  ProcessingViewController.h
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/8/24.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ProcessingType) {
    ProcessingTypeDefault,
    ProcessingTypeResetting,
    ProcessingTypeSettingUp
};

@interface ProcessingViewController : UIViewController
@property (nonatomic) ProcessingType processingType;
@end
