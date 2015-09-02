//
//  Menu.m
//  AuthenticatorCircle
//
//  Created by Andy on 15/8/15.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "Menu.h"

@interface Menu ()
@property (nonatomic, strong) IBOutlet UILabel *lb_CopyRights;
@end

@implementation Menu {
    BOOL isCopyRightFrameSet;
}
@synthesize lb_CopyRights;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:54.0/255.0 green:61.0/255.0 blue:78.0/255.0 alpha:1.0f]];
    [self.tableView setBackgroundColor:cBackground];
    [lb_CopyRights setBackgroundColor:cBackground];
    [lb_CopyRights sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_Done_OnClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
}

- (void)viewDidLayoutSubviews {
    if (!isCopyRightFrameSet) {
        CGRect copyRightsFrame = lb_CopyRights.frame;
        copyRightsFrame.origin.y = self.tableView.bounds.size.height - self.tableView.contentSize.height + lb_CopyRights.frame.origin.y - (108.0f - copyRightsFrame.size.height);
        copyRightsFrame.size.height = 108.0f;
        [lb_CopyRights setFrame:copyRightsFrame];
        isCopyRightFrameSet = YES;
    }
}

- (IBAction)clear:(id)sender {
    [KeychainWrapper clearKeychains:kKeychainIdentifier];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
