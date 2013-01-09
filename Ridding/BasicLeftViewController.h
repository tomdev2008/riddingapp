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
@interface BasicLeftViewController : BasicViewController <UITableViewDelegate,UITableViewDataSource,RiddingViewControllerDelegate,QQNRSourceLoginViewControllerDelegate>{
  int _nowIndexView;
  NSIndexPath *_selectedIndex;
}

@property(nonatomic,retain) IBOutlet UITableView *uiTableView;

@end
