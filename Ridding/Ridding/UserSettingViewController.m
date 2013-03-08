//
//  UserSettingViewController.m
//  Ridding
//
//  Created by zys on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserSettingViewController.h"
#import "UMFeedback.h"
#import "SinaApiRequestUtil.h"
#import "UserSettingCell.h"
#import "Utilities.h"
#import "UIImage+UIImage_Retina4.h"
#import "UserHelpViewController.h"
#import "FeedBackViewController.h"
@implementation UserSettingViewController
@synthesize uiTableView = _uiTableView;
@synthesize staticInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    staticInfo = [StaticInfo getSinglton];
  }
  return self;
}

- (void)viewDidLoad {

  self.canMoveLeft=YES;
  self.hasLeftView = TRUE;


  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  
  [self.barView.titleLabel setText:@"设置"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  self.uiTableView.backgroundColor=[UIColor clearColor];
  
  GADSearchBannerView *bannerView = [[GADSearchBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(GAD_SIZE_320x50) origin:CGPointMake(0, SCREEN_HEIGHT- 50)];
  bannerView.adUnitID = MY_BANNER_UNIT_ID;
  bannerView.rootViewController = self;
  [self.view addSubview:bannerView];
  GADSearchRequest *adRequest = [[GADSearchRequest alloc] init];
  [adRequest setQuery:@"sport"];
  [bannerView loadRequest:[adRequest request]];
  [super viewDidLoad];

}

- (void)viewDidUnload {

  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];
  self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated {

  [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

  return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark -
#pragma mark UITableView data source and delegate methods
//每个section显示的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

  return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  if (indexPath.row<5) {
    UserSettingCell *cell = (UserSettingCell *) [Utilities cellByClassName:@"UserSettingCell" inNib:@"UserSettingCell" forTableView:self.uiTableView];
    if ([indexPath row] == 0) {
      [cell initView:@"给个好评吧"];
    } else if ([indexPath row] == 1) {
      [cell initView:@"骑行者反馈"];
    } else if ([indexPath row] == 2) {
      [cell initView:@"查看新版本"];
    } else if ([indexPath row] == 3) {
      [cell initView:@"新用户指南"];
    } else if ([indexPath row] == 4) {
      [cell initView:@"高级功能"];
    }
    return cell;
  } else if (indexPath.row == 5) {
    UserLoginCell *loginCell = (UserLoginCell *) [Utilities cellByClassName:@"UserLoginCell" inNib:@"UserLoginCell" forTableView:self.uiTableView];
    loginCell.delegate=self;
    if ([[RiddingAppDelegate shareDelegate] canLogin]) {
      
      [loginCell initView:FALSE];
    } else {
      
      [loginCell initView:TRUE];
    }
    return loginCell;
  }
  return nil;
  
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  if (indexPath.row<5) {
    if ([indexPath row] == 0) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkAppStoreComment]];

    } else if ([indexPath row] == 1) {
      
      FeedBackViewController *feedBackViewController=[[FeedBackViewController alloc]init];
      [self.navigationController pushViewController:feedBackViewController animated:YES];

    } else if ([indexPath row] == 2) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkAppStore]];

    } else if ([indexPath row] == 3){
      
      UserHelpViewController *helpController=[[UserHelpViewController alloc]init];
      [self.navigationController pushViewController:helpController animated:YES];
    } else if ([indexPath row] == 4){
      
      [self updateToVIP];
    }
  }
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



- (void)quitButtonClick {

  SinaApiRequestUtil *requestUtil = [SinaApiRequestUtil getSinglton];
  [requestUtil quit];

  staticInfo.user.userId = -1;
  staticInfo.user.savatorUrl = @"";
  staticInfo.user.bavatorUrl = @"";
  staticInfo.user.name = @"";
  staticInfo.user.accessToken = @"";
  staticInfo.user.authToken = @"";
  staticInfo.logined = FALSE;
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

  [prefs removeObjectForKey:kStaticInfo_logined];
  [prefs removeObjectForKey:kStaticInfo_userId];
  [prefs removeObjectForKey:kStaticInfo_authToken];
  [prefs removeObjectForKey:kStaticInfo_accessUserId];
  [prefs removeObjectForKey:kStaticInfo_accessToken];
  [prefs removeObjectForKey:kStaticInfo_totalDistance];
  [prefs removeObjectForKey:kStaticInfo_sourceType];
  [prefs removeObjectForKey:kStaticInfo_backgroundUrl];
  [prefs removeObjectForKey:kStaticInfo_riddingCount];
  [prefs removeObjectForKey:kStaticInfo_nickname];
  [prefs removeObjectForKey:[staticInfo kRecomAppKey]];
  [RiddingAppDelegate popAllNavgation];

  PublicViewController *publicViewController = [[PublicViewController alloc] init];
  [[RiddingAppDelegate shareDelegate].navController pushViewController:publicViewController animated:NO];
  // 清空通知中心和badge

  [[NSNotificationCenter defaultCenter] postNotificationName:kSuccLogoutNotification object:nil];

  // 清除badge
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)updateToVIP {

  NSURL *url = [NSURL URLWithString:online_taobao_link_weather];
  if ([[UIApplication sharedApplication] canOpenURL:url]) {
    [[UIApplication sharedApplication] openURL:url];
  } else {
    url = [NSURL URLWithString:online_taobao_url_weather];
    [[UIApplication sharedApplication] openURL:url];
  }
}

#pragma mark - RiddingViewController delegate
- (void)didFinishLogined:(QQNRSourceLoginViewController *)controller {

  [super didFinishLogined:controller];
  [self.uiTableView reloadData];
}

#pragma mark -
#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

  return UITableViewCellEditingStyleNone;
}


- (void)btnClick:(UserLoginCell*)cell{
  
  if ([[RiddingAppDelegate shareDelegate] canLogin]) {
    [self quitButtonClick];
  } else {
    [self presentLoginView];
  }

  
}
@end
