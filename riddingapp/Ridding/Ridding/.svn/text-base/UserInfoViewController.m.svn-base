//
//  UserInfoViewController.m
//  Ridding
//
//  Created by zys on 12-9-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIColor+XMin.h"
@interface UserInfoViewController ()

@end

@implementation UserInfoViewController
@synthesize user=_user;
@synthesize nickNameLabel=_nickNameLabel;
@synthesize mileStoneLabel=_mileStoneLabel;
@synthesize avatorView=_avatorView;
@synthesize tv=_tv;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tv.backgroundColor=[UIColor getColor:@"E6E6E6"];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"CellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
	}
    if([indexPath section]==0){
        if([indexPath row]==0){
            cell.textLabel.text=@"电话:15088698307";
        }else if([indexPath row]==1){
            cell.textLabel.text=@"他的骑行活动";
        }
    }
    return cell;
}
@end
