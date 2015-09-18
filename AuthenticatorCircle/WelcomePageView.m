//
//  WelcomePageView.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/9/15.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "WelcomePageView.h"

@interface WelcomePageView ()

@end

@implementation WelcomePageView {
    NSArray *welcomePages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDelegate:self];
    [self setDataSource:self];
    welcomePages = [self initialWelcomePages];
    [self setViewControllers:@[[welcomePages objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view setBackgroundColor:cBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSArray *)initialWelcomePages {
    NSMutableArray *pages = [NSMutableArray new];
    [pages addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeHomePage"]];
    [pages addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeSyncWithiCloud"]];
    return pages;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [welcomePages indexOfObject:viewController];
    if (index < welcomePages.count - 1) {
        return [welcomePages objectAtIndex:index + 1];
    }
    else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [welcomePages indexOfObject:viewController];
    if (index > 0) {
        return [welcomePages objectAtIndex:index - 1];
    }
    else {
        return nil;
    }
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
