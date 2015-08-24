//
//  AuthenticatorSimulator.h
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/8/13.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ArcProgressView.h"

#define kSeriesNumber @"kSeriesNumber"
#define kRestoreCode @"kRestoreCode"
#define kPasscodeFadeTime 0.5f

@interface AuthenticatorSimulator : NSObject <NSCoding>
- (id)initWithSeriesNumber:(NSString *)existedSeriesNumber andRestoreCode:(NSString *)existedRestoreCode;
- (void)hookupPasscodeLabel:(UILabel *)passcodeLabel arcProgressView:(ArcProgressView *)arcProgressView;
- (void)startTimerFrom:(CGFloat)startProgress;
- (NSString *)retrieveSeriesNumber;
- (NSString *)retrieveRestoreCode;
- (void)sync;
@end
