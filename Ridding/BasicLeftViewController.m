//
//  BasicLeftViewController.m
//  Ridding
//
//  Created by zys on 12-12-3.
//
//

#import "PublicViewController.h"
#import "QQNRFeedViewController.h"
#import "RiddingAppDelegate.h"
#import "UserSettingViewController.h"
#import "SVProgressHUD.h"
#import "BasicLeftHeadView.h"
#import "BasicLeftViewCell.h"
#import "Utilities.h"

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
      cell.iconView.image = UIIMAGE_FROMPNG(@"qqnr_ln_myridding");
    }
      break;
    case 3: {
      cell.titleLabel.text = @"推荐给骑友";
      cell.iconView.image = UIIMAGE_FROMPNG(@"qqnr_ln_myridding");
      
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
      [self showShare];
      break;
    default:
      break;
  }

}

- (void)showShare {
  if([MFMessageComposeViewController canSendText]){
		
    MFMessageComposeViewController *smsComposer = [[MFMessageComposeViewController alloc] init];
		
    smsComposer.body = [NSString stringWithFormat:@"我下载了一款骑行应用叫\"骑行者\",非常不错！以后出去骑车就靠它了。可以画路线,添加队友,追踪队友位置,还能拍照记录行程。赶紧下一个去!给你链接:%@",linkAppStore];
    smsComposer.messageComposeDelegate = self;
		
    [self moveRight];
    [self presentModalViewController:smsComposer animated:NO];
  }
  else{
		
		NSString *deviceType = [UIDevice currentDevice].model;
		if([deviceType isEqualToString:@"iPhone"] ){
			
			// 老版本iphone
			
			ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
		//	picker.peoplePickerDelegate = self;
			
			// Display only a person's phone, email, and birthdate
			NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                                 [NSNumber numberWithInt:kABPersonEmailProperty],
                                 [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
			
			
			picker.displayedProperties = displayedItems;
			// Show the picker
			[self presentModalViewController:picker animated:YES];
			
		}else {
      [Utilities alertInstant:@"抱歉\n你没有发短信的功能哦" isError:YES];
		}
  }

}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
  
	[self dismissModalViewControllerAnimated:YES];
  [self restoreViewLocation];
}


- (void)showSetting {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];

  if (![self isShowingViewController:[UserSettingViewController class]]) {
    [self moveRight];
    UserSettingViewController *settingVCTL = [[UserSettingViewController alloc] init];
    [RiddingAppDelegate popAllNavgation];
    [delegate.navController pushViewController:settingVCTL animated:NO];
  }
  [self restoreViewLocation];

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
