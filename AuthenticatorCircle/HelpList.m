//
//  HelpList.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/9/11.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "HelpList.h"
#import "HelpContent.h"

@interface HelpList ()

@end

@implementation HelpList {
    NSArray *helpList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    helpList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HelpContents" ofType:@"plist"]];
    [self.tableView setEstimatedRowHeight:44.0f];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return helpList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HelpTitleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    //Set SeperatorInset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //Set help title
    [cell.textLabel setText:[[helpList objectAtIndex:indexPath.row] objectForKey:kHelpTitleKey]];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSDictionary *helpDetails = [helpList objectAtIndex:[self.tableView indexPathForCell:sender].row];
    HelpContent *helpContent = segue.destinationViewController;
    [helpContent setHelpDetail:helpDetails];
}


@end
