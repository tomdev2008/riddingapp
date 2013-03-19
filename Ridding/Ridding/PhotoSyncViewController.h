//
//  PhotoSyncViewController.h
//  Ridding
//
//  Created by zys on 13-3-14.
//
//

#import "BasicViewController.h"
#import "BasicViewController.h"
#import "GADSearchBannerView.h"
#import "GADSearchRequest.h"
@interface PhotoSyncViewController : BasicViewController<UITableViewDelegate, UITableViewDataSource,GADBannerViewDelegate>{
  int _count;
}


@property (nonatomic, retain) IBOutlet UITableView *uiTableView;

- (id)initWithCount:(int)count;
@end
