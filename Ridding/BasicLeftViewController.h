//
//  BasicLeftViewController.h
//  Ridding
//
//  Created by zys on 12-12-3.
//
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "RiddingViewController.h"
#import "QQNRSourceLoginViewController.h"
#import "BasicLeftFootView.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface BasicLeftViewController : BasicViewController <UITableViewDelegate, UITableViewDataSource, RiddingViewControllerDelegate, QQNRSourceLoginViewControllerDelegate, BasicLeftFootViewDelegate,MFMessageComposeViewControllerDelegate> {
  NSIndexPath *_selectedIndex;
  BasicLeftFootView *_footView;
}

@property (nonatomic, retain) IBOutlet UITableView *uiTableView;
@property (nonatomic, retain) IBOutlet UIImageView *shadowImageView;


- (void)showShadow;
@end
