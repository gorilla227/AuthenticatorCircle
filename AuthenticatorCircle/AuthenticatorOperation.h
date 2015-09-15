//
//  AuthenticatorOperation.h
//  AuthenticatorCircle
//
//  Created by Andy on 15/9/13.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticatorOperation : NSObject
+ (AuthenticatorSimulator *)loadFromFile:(NSString *)filePath;
+ (AuthenticatorSimulator *)loadFromCloud;
+ (BOOL)save:(AuthenticatorSimulator *)authenticator toFile:(NSString *)filePath;
+ (BOOL)saveToCloud:(AuthenticatorSimulator *)authenticator;
+ (BOOL)clearLocalFile:(NSString *)filePath;
+ (BOOL)clearCloud;
@end
