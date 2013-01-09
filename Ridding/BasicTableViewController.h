//
//  BasicTableViewController.h
//  Ridding
//
//  Created by zys on 12-9-28.
//
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
@interface BasicTableViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate>{

}

@property(nonatomic,retain) IBOutlet UITableView *tv;

@end
