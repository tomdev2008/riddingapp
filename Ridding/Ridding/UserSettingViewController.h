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

#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface UserSettingViewController : BasicNeedLoginViewController <UITableViewDelegate, UITableViewDataSource, QQNRSourceLoginViewControllerDelegate, RiddingViewControllerDelegate,MFMessageComposeViewControllerDelegate> {
  StaticInfo *staticInfo;
    NSMutableDictionary *_userPays;
  int _count;
}
@property (nonatomic, retain) IBOutlet UITableView *uiTableView;
@property (nonatomic, retain) StaticInfo *staticInfo;


- (id)initWithLeftView:(BOOL)hasLeftView;

@end
