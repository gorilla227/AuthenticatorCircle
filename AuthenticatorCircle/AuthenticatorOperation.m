//
//  AuthenticatorOperation.m
//  AuthenticatorCircle
//
//  Created by Andy on 15/9/13.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "AuthenticatorOperation.h"

@implementation AuthenticatorOperation

#pragma Load
+ (AuthenticatorSimulator *)loadFromFile:(NSString *)filePath {
    if (filePath) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    return nil;
}

+ (AuthenticatorSimulator *)loadFromCloud {
    //Restore from iCloud
    NSArray *existedKeychains = [KeychainWrapper retriveKeychainsByAttributes:kKeychainIdentifier];
    for (NSDictionary *keychainAttribute in existedKeychains) {
        if ([[keychainAttribute objectForKey:(__bridge id)kSecAttrAccount] isEqual:kKeychainAccount] && [[keychainAttribute objectForKey:(__bridge id)kSecAttrService] isEqual:kKeychainService]) {
            //Authenticator Existed
            KeychainWrapper *keychainItem = [[KeychainWrapper alloc] initWithAttributes:keychainAttribute];
            AuthenticatorSimulator *authenticator = [NSKeyedUnarchiver unarchiveObjectWithData:keychainItem.keychainData];
            return authenticator;
        }
    }
    return nil;
}

+ (BOOL)save:(AuthenticatorSimulator *)authenticator toFile:(NSString *)filePath {
    if (authenticator && filePath) {
        return [NSKeyedArchiver archiveRootObject:authenticator toFile:filePath];
    }
    else {
        return NO;
    }
}

#pragma Save
+ (BOOL)saveToCloud:(AuthenticatorSimulator *)authenticator {
    if (authenticator) {
        NSData *authenticatorData = [NSKeyedArchiver archivedDataWithRootObject:authenticator];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
        [NSKeyedArchiver archiveRootObject:authenticator toFile:filePath];
        NSArray *existedKeychains = [KeychainWrapper retriveKeychainsByAttributes:kKeychainIdentifier];
        for (NSDictionary *keychainAttribute in existedKeychains) {
            if ([[keychainAttribute objectForKey:(__bridge id)kSecAttrAccount] isEqual:kKeychainAccount] && [[keychainAttribute objectForKey:(__bridge id)kSecAttrService] isEqual:kKeychainService]) {
                //Authenticator Existed
                KeychainWrapper *keychainItem = [[KeychainWrapper alloc] initWithAttributes:keychainAttribute];
                [keychainItem deleteKeychain];
                break;
            }
        }
        
        KeychainWrapper *keychainItem = [[KeychainWrapper alloc] initWithNewKeychain:@{(__bridge id)kSecAttrAccount:kKeychainAccount,
                                                                                       (__bridge id)kSecAttrService:kKeychainService,
                                                                                       (__bridge id)kSecAttrGeneric:[kKeychainIdentifier dataUsingEncoding:NSUTF8StringEncoding],
                                                                                       (__bridge id)kSecValueData:authenticatorData}];
        return keychainItem.keychainData;
    }
    else {
        return NO;
    }
}

#pragma Clear
+ (BOOL)clearLocalFile:(NSString *)filePath {
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

+ (BOOL)clearCloud {
    return [KeychainWrapper clearKeychains:kKeychainIdentifier];
}
@end
