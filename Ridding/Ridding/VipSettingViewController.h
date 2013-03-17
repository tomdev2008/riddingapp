//
//  VipSettingViewController.h
//  Ridding
//
//  Created by zys on 13-3-15.
//
//

#import <UIKit/UIKit.h>

@interface VipSettingViewController : BasicViewController<UITableViewDelegate, UITableViewDataSource>{
  NSMutableDictionary *_userPays;
}


@property (nonatomic, retain) IBOutlet UITableView *uiTableView;
@end
