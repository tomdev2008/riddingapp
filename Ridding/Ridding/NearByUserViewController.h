//
//  NearByUserViewController.h
//  Ridding
//
//  Created by zys on 13-2-8.
//
//

#import "BasicViewController.h"
#import "BasicTableViewController.h"

@interface NearByUserViewController : BasicTableViewController< UP_EGORefreshTableHeaderDelegate,EGORefreshTableHeaderDelegate, UINavigationControllerDelegate>{
  UP_EGORefreshTableHeaderView *_ego;
  EGORefreshTableHeaderView *_top_Ego;
  NSMutableArray *_dataSource;
  BOOL _isLoading;
  BOOL _isLoadOld;
  BOOL _isTheEnd;
  int _endOffset;
}

@end
