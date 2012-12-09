//
//  BasicLeftViewController.h
//  Ridding
//
//  Created by zys on 12-12-3.
//
//

#import <UIKit/UIKit.h>

@interface BasicLeftViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
  int _nowIndexView;
}

@property(nonatomic,retain) IBOutlet UITableView *uiTableView;

@end
