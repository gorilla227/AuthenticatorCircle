//
//  AuthenticatorSimulator.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/8/13.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "AuthenticatorSimulator.h"

@implementation AuthenticatorSimulator {
    NSString *seriesNumber;
    NSString *restoreCode;
    UILabel *lb_Passcode;
    ArcProgressView *apv_ArcProgress;
}
- (id)initWithSeriesNumber:(NSString *)existedSeriesNumber andRestoreCode:(NSString *)existedRestoreCode {
    self = [super init];
    if (self) {
        if (existedSeriesNumber && existedRestoreCode) {
            seriesNumber = existedSeriesNumber;
            restoreCode = existedRestoreCode;
        }
        else if (existedSeriesNumber){//In this case, existedSeriesNumber is the region code such as "CN" or "US". Simulator will generate following 12-digi to complete Series Number and generate the restoreCode
            //Generate Series Number
            seriesNumber = existedSeriesNumber;
            for (int i = 0; i < 3; i++) {
                NSString *seriesNumberCell = [NSNumber numberWithInt:arc4random() % 10000].stringValue;
                while (seriesNumberCell.length < 4) {
                    seriesNumberCell = [@"0" stringByAppendingString:seriesNumberCell];
                }
                seriesNumber = [NSString stringWithFormat:@"%@-%@", seriesNumber, seriesNumberCell];
            }
            
            //Generate Restoce Code
            restoreCode = [NSString new];
            while (restoreCode.length < 10) {
                NSString *restoreCodeChar = [NSString stringWithFormat:@"%c", arc4random() % 26 + 65];
                restoreCode = [restoreCode stringByAppendingString:restoreCodeChar];
            }
        }
        else {
            self = nil;
        }
    }
    return self;
}

- (void)hookupPasscodeLabel:(UILabel *)passcodeLabel arcProgressView:(ArcProgressView *)arcProgressView {
    lb_Passcode = passcodeLabel;
    apv_ArcProgress = arcProgressView;
    if (lb_Passcode && apv_ArcProgress) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPasscode:) name:kRepeatNotification object:nil];
    }
}

- (void)refreshPasscode:(NSNotification *)notification {
    [UIView animateWithDuration:kPasscodeFadeTime animations:^{
        [lb_Passcode setAlpha:0];
    } completion:^(BOOL finished) {
        [lb_Passcode setText:[self passcodeString]];
        [UIView animateWithDuration:kPasscodeFadeTime animations:^{
            [lb_Passcode setAlpha:1];
        }];
    }];
}

- (NSString *)passcodeString {
    NSString *randomString = [NSNumber numberWithInt:(arc4random() % 100000000)].stringValue;
    while (randomString.length < 8) {
        randomString = [NSString stringWithFormat:@"0%@", randomString];
    }
    return randomString;
}

- (void)startTimerFrom:(CGFloat)startProgress {
    if (apv_ArcProgress && lb_Passcode) {
        [apv_ArcProgress changeProgress:startProgress isAnimated:NO];
        [lb_Passcode setText:[self passcodeString]];
        [apv_ArcProgress startAnimation];
    }
}

- (NSString *)retrieveSeriesNumber {
    return [seriesNumber copy];
}

- (NSString *)retrieveRestoreCode {
    return [restoreCode copy];
}

- (void)sync {
    [self startTimerFrom:(float)(arc4random() % 10) / 10];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:seriesNumber forKey:kSeriesNumber];
    [aCoder encodeObject:restoreCode forKey:kRestoreCode];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        seriesNumber = [aDecoder decodeObjectForKey:kSeriesNumber];
        restoreCode = [aDecoder decodeObjectForKey:kRestoreCode];
    }
    return self;
}
@end
