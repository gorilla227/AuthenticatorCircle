//
//  AppDelegate.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/8/12.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize gAuthenticator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Initial gUIStrings
    NSString *filePathOfUIStrings = [[NSBundle mainBundle] pathForResource:@"UIStrings" ofType:@"plist"];
    gUIStrings = [NSDictionary dictionaryWithContentsOfFile:filePathOfUIStrings];
    
#warning Debug Lines Start
//    [KeychainWrapper clearKeychains:kKeychainIdentifier];
//    [[NSFileManager defaultManager] removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile] error:nil];
#warning Debug Lines End
    
    //Set appearance
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:54.0/255.0 green:61.0/255.0 blue:78.0/255.0 alpha:1.0f]];
//    [[UINavigationBar appearance] setTranslucent:NO];
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:kLocalSavingFile];
    AuthenticatorSimulator *localAuthenticator = [AuthenticatorOperation loadFromFile:filePath];
    AuthenticatorSimulator *cloudAuthenticator = [AuthenticatorOperation loadFromCloud];

    if (!localAuthenticator && !cloudAuthenticator) {
        //New User
        [self.window setRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WelcomePageView"]];
    }
    else if (!localAuthenticator && cloudAuthenticator) {
        //New Device -> InitialViewController
        [self.window setRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InitialNavi"]];
    }
    else if (localAuthenticator && !cloudAuthenticator) {
        //If shouldn't be this situation -> Save local authenticator to iCloud
        [AuthenticatorOperation saveToCloud:localAuthenticator];
        [self setGAuthenticator:localAuthenticator];
    }
    else {
        //Both LocalAuthenticator and CloudAuthenticator existed
        if ([[localAuthenticator retrieveSeriesNumber] isEqualToString:[cloudAuthenticator retrieveSeriesNumber]]) {
            //LocalAuthenticator equals to CloudAuthenticator -> Launch ShowAuthenticator
            [self setGAuthenticator:localAuthenticator];
        }
        else {
            //LocalAuthenticatr is not consistent with CloudAuthenticator -> Ask user to make a chioce
            [self.window setRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FixInconsistency"]];
        }
    }
    
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end