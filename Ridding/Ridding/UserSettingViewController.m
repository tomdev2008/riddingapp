//
//  UserSettingViewController.m
//  Ridding
//
//  Created by zys on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserSettingViewController.h"
#import "UMFeedback.h"
#import "UIColor+XMin.h"
#import "SinaApiRequestUtil.h"

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

  [super viewDidLoad];
  self.hasLeftView = TRUE;


  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];

  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  self.uiTableView.backgroundColor=[UIColor clearColor];
  
  GADSearchBannerView *bannerView = [[GADSearchBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(GAD_SIZE_320x50) origin:CGPointMake(0, SCREEN_HEIGHT- 50)];
  bannerView.adUnitID = MY_BANNER_UNIT_ID;
  bannerView.rootViewController = self;
  [self.view addSubview:bannerView];
  GADSearchRequest *adRequest = [[GADSearchRequest alloc] init];
  [adRequest setQuery:@"sport"];
  [bannerView loadRequest:[adRequest request]];

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

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  if (section == 0) {
    return 3;//推荐、帮助、升级
  }
  if (section == 1) {
    return 2;//退出,注销
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *kCellID = @"CellID";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
  }
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  if ([indexPath section] == 0) {
    if ([indexPath row] == 0) {
      cell.textLabel.text = @"喜欢这款应用吗?";
    } else if ([indexPath row] == 1) {
      cell.textLabel.text = @"骑行者反馈";
    } else if ([indexPath row] == 2) {
      cell.textLabel.text = @"查看新版本!有惊喜!";
    }
  } else if ([indexPath section] == 1) {
    if ([indexPath row] == 0) {
      if ([[RiddingAppDelegate shareDelegate] canLogin]) {
        cell.textLabel.text = @"退出";
      } else {
        cell.textLabel.text = @"登录";
      }
    } else {
      cell.textLabel.text = @"升级成为会员";
    }
  }
  cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 20, 20);
  cell.textLabel.textColor = [UIColor getColor:@"303030"];
  cell.textLabel.font = [UIFont systemFontOfSize:14];
  return cell;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  if ([indexPath section] == 0) {
    if ([indexPath row] == 0) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkAppStoreComment]];

    } else if ([indexPath row] == 1) {
      NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
      SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(staticInfo.user.userId), @"userid");
      SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, staticInfo.user.name, @"nickname");
      [UMFeedback showFeedback:self withAppkey:@"4fb3ce805270152b53000128" dictionary:dic];
      self.navigationController.navigationBarHidden = NO;

    } else if ([indexPath row] == 2) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkAppStore]];

    }
  } else if ([indexPath section] == 1) {
    if ([indexPath row] == 0) {
      if ([[RiddingAppDelegate shareDelegate] canLogin]) {
        [self quitButtonClick];
      } else {
        [self presentLoginView];
      }
    } else {
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
  [prefs removeObjectForKey:kStaticInfo_apnsToken];
  [prefs removeObjectForKey:kStaticInfo_riddingCount];
  [prefs removeObjectForKey:kStaticInfo_nickname];
  [RiddingAppDelegate popAllNavgation];

  PublicViewController *publicViewController = [[PublicViewController alloc] init];
  [[RiddingAppDelegate shareDelegate].navController pushViewController:publicViewController animated:NO];
  // 清空通知中心和badge

  [[NSNotificationCenter defaultCenter] postNotificationName:kSuccLogoutNotification object:nil];

  // 清除badge
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)updateToVIP {

  NSURL *url = [NSURL URLWithString:@"taobao://item.taobao.com/item.htm?id=12688928896"];
  if ([[UIApplication sharedApplication] canOpenURL:url]) {
    [[UIApplication sharedApplication] openURL:url];
  } else {
    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://item.taobao.com/item.htm?id=12688928896"]];
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

  return 44;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

  return UITableViewCellEditingStyleNone;
}
@end
