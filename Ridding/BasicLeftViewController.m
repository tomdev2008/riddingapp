//
//  BasicLeftViewController.m
//  Ridding
//
//  Created by zys on 12-12-3.
//
//

#import "BasicLeftViewController.h"
#import "PublicViewController.h"
#import "QQNRFeedViewController.h"
#import "RiddingAppDelegate.h"
#import "RequestUtil.h"
#import "RiddingViewController.h"
#import "BasicViewController.h"
#import "UserSettingViewController.h"
#import "MapCreateVCTL.h"
#import "SVProgressHUD.h"
@interface BasicLeftViewController (){
  
}

@end

@implementation BasicLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.uiTableView.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"leftbar_dt")];
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"leftbar_dt")];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
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
  static NSString *kCellID = @"CellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
  if(!cell){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView =  [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"leftbar_dt_xz")];
    
  }
  cell.textLabel.textColor=[UIColor whiteColor];
  cell.textLabel.backgroundColor=[UIColor clearColor];
  cell.textLabel.font=[UIFont systemFontOfSize:12];
  switch (indexPath.row) {
    case 0:
    {
      [cell.textLabel setText:@"个人中心"];
    }
      break;
    case 1:
    {
      [cell.textLabel setText:@"创建活动"];
    }
      break;
    case 2:
    {
      [cell.textLabel setText:@"广场"];
    }
      break;
    case 3:
    {
      [cell.textLabel setText:@"设置"];
      cell.imageView.image=UIIMAGE_FROMPNG(@"setting");
    }
      break;
    default:
      break;
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  _selectedIndex=indexPath;
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
     [self showSetting];
      break;
      
    default:
      break;
  }
}

- (void)showSetting{
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  
  if(![self isShowingViewController:[UserSettingViewController class]]){
    [RiddingAppDelegate moveRightNavgation];
    UserSettingViewController *settingVCTL=[[UserSettingViewController alloc]init];
    [RiddingAppDelegate popAllNavgation];
    [delegate.navController pushViewController:settingVCTL animated:NO];
  }
  [RiddingAppDelegate moveLeftNavgation];
  
}

- (void)showUserFeed{
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  if([delegate canLogin]){
    if(![self isShowingViewController:[QQNRFeedViewController class]]){
      [RiddingAppDelegate moveRightNavgation];
      //如果新浪成功，并且authtoken有效
      QQNRFeedViewController *FVC=[[QQNRFeedViewController alloc]initWithUser:[StaticInfo getSinglton].user isFromLeft:TRUE];

      [RiddingAppDelegate popAllNavgation];
      [delegate.navController pushViewController:FVC animated:NO];
    }
    
    [RiddingAppDelegate moveLeftNavgation];
  }else{
    [RiddingAppDelegate moveRightNavgation];
    RiddingViewController *riddingViewController=[[RiddingViewController alloc]init];
    riddingViewController.delegate=self;
    [self presentModalViewController:riddingViewController animated:YES];
  }
  _nowIndexView=1;
}


- (void)showCreateMap{
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  
  if(![self isShowingViewController:[MapCreateVCTL class]]){
    [RiddingAppDelegate moveRightNavgation];
    MapCreateVCTL *mapCreateVCTL=[[MapCreateVCTL alloc]init];
    [delegate.navController pushViewController:mapCreateVCTL animated:NO];
  }
  [RiddingAppDelegate moveLeftNavgation];
}

- (void)showPublic{
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
    if(![self isShowingViewController:[PublicViewController class]]){
      [RiddingAppDelegate moveRightNavgation];
      PublicViewController *publicVCTL=[[PublicViewController alloc]init];
      [delegate.navController pushViewController:publicVCTL animated:NO];
    }
  [SVProgressHUD dismiss];
  [RiddingAppDelegate moveLeftNavgation];
}

- (void)didClickLogin:(RiddingViewController*)controller{
  [controller dismissModalViewControllerAnimated:NO];
  QQNRSourceLoginViewController *loginController=[[QQNRSourceLoginViewController alloc]init];
  loginController.delegate=self;
  [self presentModalViewController:loginController animated:YES];
}

#pragma mark - RiddingViewController delegate
- (void)didFinishLogined:(QQNRSourceLoginViewController*)controller{
  [controller dismissModalViewControllerAnimated:NO];
  [self tableView:self.uiTableView didSelectRowAtIndexPath:_selectedIndex];
}



- (BOOL)isShowingViewController:(Class)class{
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  if([delegate.navController.visibleViewController isKindOfClass:class]){
    return TRUE;
  }
  return FALSE;
}

- (void)popAllNavgationSubView{
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  [delegate.navController popToRootViewControllerAnimated:NO];
  [delegate.navController popViewControllerAnimated:NO];
}



@end
