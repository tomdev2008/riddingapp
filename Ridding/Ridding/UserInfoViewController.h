//
//  UserInfoViewController.h
//  Ridding
//
//  Created by zys on 12-9-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "User.h"

@interface UserInfoViewController : BasicViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, retain) User *user;
@property (nonatomic, retain) IBOutlet UIImageView *avatorView;
@property (nonatomic, retain) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *mileStoneLabel;
@property (nonatomic, retain) IBOutlet UITableView *tv;

@end
