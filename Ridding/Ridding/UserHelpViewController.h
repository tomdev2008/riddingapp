//
//  UserHelpViewController.h
//  Ridding
//
//  Created by zys on 13-3-5.
//
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "GADSearchBannerView.h"
#import "GADSearchRequest.h"
@interface UserHelpViewController : BasicViewController<UITableViewDelegate, UITableViewDataSource,GADBannerViewDelegate>



@property (nonatomic, retain) IBOutlet UITableView *uiTableView;

@end
