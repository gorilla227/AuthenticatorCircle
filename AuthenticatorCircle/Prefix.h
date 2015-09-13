//
//  Prefix.h
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/8/14.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#ifndef AuthenticatorCircle_Prefix_h
#define AuthenticatorCircle_Prefix_h
//Global Variables
extern NSDictionary *gUIStrings;
#endif

#define cBackground [UIColor colorWithRed:33.0/255.0 green:38.0/255.0 blue:53.0/255.0 alpha:1.0f]
#define cViewBackground [UIColor colorWithPatternImage:[UIImage imageNamed:@"AppBackground.jpg"]]
#define cTextFieldBackground [UIColor colorWithWhite:0.1f alpha:0.8f]
#define kKeychainIdentifier @"AuthenticatorIdentifier"
#define kKeychainAccount @"AuthenticatorAccount"
#define kKeychainService @"AuthenticatorService"
#define kLocalSavingFile @"Authenticator.saving"
#define kButtonCornerRadius 2.0f
#define kTextFieldCornerRadius 1.0f
#define kSerialKey @"SerialKey"
#define kRestoreCodeKey @"RestoreCodeKey"
#define kSetupRegionCodeKey @"SetupRegionCodeKey"
#define kLinkSeperator @"#$"