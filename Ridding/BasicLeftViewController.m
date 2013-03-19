//
//  BasicLeftViewController.m
//  Ridding
//
//  Created by zys on 12-12-3.
//
//

#import "QQNRFeedViewController.h"
#import "UserSettingViewController.h"
#import "SVProgressHUD.h"
#import "BasicLeftHeadView.h"
#import "BasicLeftViewCell.h"
#import "Utilities.h"
#import "RiddingNearByViewController.h"
#import "FeedBackViewController.h"
#import "MapCreateChoiceVCTL.h"
@interface BasicLeftViewController () {

}

@end

@implementation BasicLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  
  self.uiTableView.backgroundColor=[UIColor clearColor];
  self.uiTableView.tableHeaderView = [[BasicLeftHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
  _footView = [[BasicLeftFootView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT- 60, SCREEN_WIDTH, 60)];
  _footView.delegate = self;
  [self.view addSubview:_footView];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSuccLoginNotif:) name:kSuccLoginNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSuccLogoutNotif:) name:kSuccLogoutNotification object:nil];
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return 4;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  BasicLeftViewCell *cell = (BasicLeftViewCell *) [Utilities cellByClassName:@"BasicLeftViewCell" inNib:@"BasicLeftViewCell" forTableView:tableView];
  [cell disSelected];

  switch (indexPath.row) {
    case 0: {
      cell.titleLabel.text = @"我的骑记";
      cell.iconView.image = UIIMAGE_FROMPNG(@"qqnr_ln_myridding");
    }
      break;
    case 1: {
      cell.titleLabel.text = @"新建骑记";
      cell.iconView.image = UIIMAGE_FROMPNG(@"qqnr_ln_create");
    }
      break;
    case 2: {
      cell.titleLabel.text = @"骑行广场";
      cell.iconView.image = UIIMAGE_FROMPNG(@"qqnr_ln_pd");
    }
      break;
    case 3: {
      
      cell.titleLabel.text = @"附近路线";
      cell.iconView.image = UIIMAGE_FROMPNG(@"qqnr_ln_icon_line");
      
      break;
    }case 4: {
      cell.titleLabel.text = @"用户反馈";
      cell.iconView.image = UIIMAGE_FROMPNG(@"qqnr_ln_recommend");
      break;
    }
    default:
      break;
  }

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  return 60;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  BasicLeftViewCell *selectedCell = (BasicLeftViewCell *) [tableView cellForRowAtIndexPath:_selectedIndex];
  [selectedCell disSelected];

  BasicLeftViewCell *cell = (BasicLeftViewCell *) [tableView cellForRowAtIndexPath:indexPath];;
  [cell selected];
  _selectedIndex = indexPath;
  switch ([indexPath row]) {
    case 0:
      [self showUserFeed];
      break;
    case 1:
      [self showCreateMap];
      break;
    case 2:
      [self showPublic];
      break;
    case 3:
      [self showNearBy];
      break;
    case 4:
      [self showCallBack];
      break;
    default:
      break;
  }

}

- (void)showCallBack{
  
  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  if ([delegate canLogin]) {
    if (![self isShowingViewController:[FeedBackViewController class]]) {
      [self moveRight];
      //如果新浪成功，并且authtoken有效
      FeedBackViewController *feedBack = [[FeedBackViewController alloc]init:YES];
      [RiddingAppDelegate popAllNavgation];
      [delegate.navController pushViewController:feedBack animated:NO];
    }
    [self restoreViewLocation];
  } else {
    [self moveRight];
    RiddingViewController *riddingViewController = [[RiddingViewController alloc] init];
    riddingViewController.delegate = self;
    [self presentModalViewController:riddingViewController animated:YES];
  }
}

- (void)showSetting {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];

    if (![self isShowingViewController:[UserSettingViewController class]]) {
      [self moveRight];
      UserSettingViewController *settingVCTL = [[UserSettingViewController alloc] initWithLeftView:YES];
      [RiddingAppDelegate popAllNavgation];
      [delegate.navController pushViewController:settingVCTL animated:NO];
    }
    [self restoreViewLocation];
 

}


- (void)showNearBy {
  [MobClick event:@"2013031901"];
  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  if ([delegate canLogin]) {
    if (![self isShowingViewController:[RiddingNearByViewController class]]) {
      [self moveRight];
      RiddingNearByViewController *nearByViewController=[[RiddingNearByViewController alloc]init];
      [RiddingAppDelegate popAllNavgation];
      [delegate.navController pushViewController:nearByViewController animated:NO];
    }
    [self restoreViewLocation];
  }else{
    [self moveRight];
    RiddingViewController *riddingViewController = [[RiddingViewController alloc] init];
    riddingViewController.delegate = self;
    [self presentModalViewController:riddingViewController animated:YES];
  }
  
}

- (void)showUserFeed {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  if ([delegate canLogin]) {
    if (![self isShowingViewController:[QQNRFeedViewController class]]) {
      [self moveRight];
      //如果新浪成功，并且authtoken有效
      QQNRFeedViewController *FVC = [[QQNRFeedViewController alloc] initWithUser:[StaticInfo getSinglton].user isFromLeft:TRUE];

      [RiddingAppDelegate popAllNavgation];
      [delegate.navController pushViewController:FVC animated:NO];
    }
    [self restoreViewLocation];
  } else {
    [self moveRight];
    RiddingViewController *riddingViewController = [[RiddingViewController alloc] init];
    riddingViewController.delegate = self;
    [self presentModalViewController:riddingViewController animated:YES];
  }
}


- (void)showCreateMap {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  if ([delegate canLogin]) {
    if (![self isShowingViewController:[MapCreateVCTL class]]) {
      self.shadowImageView.hidden = YES;
      [self moveRight];

      MapCreateVCTL *mapCreateVCTL = [[MapCreateVCTL alloc] init];
      [delegate.navController pushViewController:mapCreateVCTL animated:NO];
    }
    [self restoreViewLocation];
  } else {
    [self moveRight];
    RiddingViewController *riddingViewController = [[RiddingViewController alloc] init];
    riddingViewController.delegate = self;
    [self presentModalViewController:riddingViewController animated:YES];
  }
//接下去版本
//  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
//  if ([delegate canLogin]) {
//    if (![self isShowingViewController:[MapCreateChoiceVCTL class]]) {
//      self.shadowImageView.hidden = YES;
//      [self moveRight];
//      
//      MapCreateChoiceVCTL *mapCreateChoiceVCTL = [[MapCreateChoiceVCTL alloc] init];
//      [delegate.navController pushViewController:mapCreateChoiceVCTL animated:NO];
//    }
//    [self restoreViewLocation];
//  } else {
//    [self moveRight];
//    RiddingViewController *riddingViewController = [[RiddingViewController alloc] init];
//    riddingViewController.delegate = self;
//    [self presentModalViewController:riddingViewController animated:YES];
//  }
}

- (void)showPublic {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  if (![self isShowingViewController:[PublicViewController class]]) {
    [self moveRight];
    PublicViewController *publicVCTL = [[PublicViewController alloc] init];
    [delegate.navController pushViewController:publicVCTL animated:NO];
  }
  [SVProgressHUD dismiss];
  [self restoreViewLocation];
}

#pragma mark - RiddingViewController delegate
- (void)didClickLogin:(RiddingViewController *)controller {

  [controller dismissModalViewControllerAnimated:NO];
  QQNRSourceLoginViewController *loginController = [[QQNRSourceLoginViewController alloc] init];
  loginController.delegate = self;
  [self presentModalViewController:loginController animated:YES];
}


- (void)didFinishLogined:(QQNRSourceLoginViewController *)controller {

  [controller dismissModalViewControllerAnimated:NO];
  [self tableView:self.uiTableView didSelectRowAtIndexPath:_selectedIndex];
}


- (BOOL)isShowingViewController:(Class)class {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  if ([delegate.navController.visibleViewController isKindOfClass:class]) {
    return TRUE;
  }
  return FALSE;
}

- (void)popAllNavgationSubView {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  [delegate.navController popToRootViewControllerAnimated:NO];
  [delegate.navController popViewControllerAnimated:NO];
}

- (void)moveRight {

  self.shadowImageView.hidden = YES;
  [RiddingAppDelegate moveRightNavgation];
}

- (void)showShadow {

  self.shadowImageView.hidden = NO;
}

#pragma mark BasicLeftViewDelegate 
- (void)settingBtnClick {

  [self showSetting];
}

- (void)avatorBtnClick {

  [self tableView:self.uiTableView didSelectRowAtIndexPath:0];
}

- (void)handleSuccLoginNotif:(NSNotification *)notif {

  [_footView setUser];
}

- (void)handleSuccLogoutNotif:(NSNotification *)notif {

  [_footView resetUser];
}

@end
