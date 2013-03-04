//
//  UserSettingViewController.h
//  Ridding
//
//  Created by zys on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticInfo.h"
#import "BasicNeedLoginViewController.h"
#import "MapCreateVCTL.h"
#import "GADSearchBannerView.h"
#import "GADSearchRequest.h"
#import "UserLoginCell.h"
@interface UserSettingViewController : BasicNeedLoginViewController <UITableViewDelegate, UITableViewDataSource, QQNRSourceLoginViewControllerDelegate, RiddingViewControllerDelegate,GADBannerViewDelegate,UserLoginCellDelegate> {
  StaticInfo *staticInfo;
}
@property (nonatomic, retain) IBOutlet UITableView *uiTableView;
@property (nonatomic, retain) StaticInfo *staticInfo;


@end
