//
//  UserSettingViewController.m
//  Ridding
//
//  Created by zys on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserSettingViewController.h"
#import "PhotoSyncViewController.h"
#import "UMFeedback.h"
#import "SinaApiRequestUtil.h"
#import "UserSettingCell.h"
#import "VipSettingViewController.h"
#import "UIColor+XMin.h"
#import "Utilities.h"
#import "RiddingPictureDao.h"
#import "UIImage+UIImage_Retina4.h"
#import "UserHelpViewController.h"
#import "FeedBackViewController.h"
#import "UserPay.h"
#import "VipViewController.h"
@implementation UserSettingViewController
@synthesize staticInfo;

- (id)initWithLeftView:(BOOL)hasLeftView{
  self=[super init];
  if(self){
    staticInfo = [StaticInfo getSinglton];
    self.hasLeftView=hasLeftView;
  }
  return self;
}

- (void)viewDidLoad {

  self.canMoveLeft=YES;
  [super viewDidLoad];
  if(self.hasLeftView){
    [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list") forState:UIControlStateNormal];
    [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list_hl") forState:UIControlStateHighlighted];
  }else{
    [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
    [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  }
 
  [self.barView.leftButton setHidden:NO];
  
  [self.barView.titleLabel setText:@"设置"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  self.uiTableView.backgroundColor=[UIColor clearColor];
  self.uiTableView.backgroundView.alpha=0;
  self.uiTableView.separatorColor=[UIColor getColor:@"838788"];
  _userPays=[[NSMutableDictionary alloc]init];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(succUploadPicture:)
                                               name:kSuccUploadPictureNotification object:nil];

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

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if(!self.didAppearOnce){
    self.didAppearOnce=YES;

    dispatch_queue_t q;
    q = dispatch_queue_create("tryBtnClickDisPatch", NULL);
    dispatch_async(q, ^{
      _count= [RiddingPictureDao getRiddingPictureCount];
#ifdef isProVersion
#else
      NSArray *array=[self.requestUtil getUserPays:-1];
      if(array){
        for(NSDictionary *dic in array){
          UserPay *userPay=[[UserPay alloc]initWithJSONDic:[dic objectForKey:keyUserPay]];
          [_userPays setObject:userPay forKey:INT2NUM(userPay.type)];
        }
      }
#endif
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.uiTableView reloadData];
      });
      
    });

  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

  return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark -
#pragma mark UITableView data source and delegate methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
  UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
  myView.backgroundColor = [UIColor clearColor];
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 90, 22)];
  titleLabel.textColor=[UIColor getColor:@"A9A9A9"];
  titleLabel.font=[UIFont boldSystemFontOfSize:17];
  titleLabel.backgroundColor = [UIColor clearColor];
  if(section==0){
    titleLabel.text= @"功能";
  }else if(section==1){
    titleLabel.text= @"关于骑行者";
  }else if(section==2){
    titleLabel.text= @"推荐";
  }
  [myView addSubview:titleLabel];
  return myView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  if(section==0){
    return 2;
  }else if(section==1){
    return 4;
  }else if(section==2){
    return 1;
  }else{
    return 1;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if(indexPath.section<=2){
    static NSString *SimpleTableIdentifier = @"UserSettingIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier: SimpleTableIdentifier];
    }
    cell.backgroundColor=[UIColor getColor:@"D1D1D1"];
    cell.textLabel.textColor=[UIColor getColor:@"363636"];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image=UIIMAGE_FROMPNG(@"qqnr_system_icon");
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell.accessoryView addSubview:imageView];
    UILabel *descLabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 15, 80, 20)];
    descLabel.textColor=[UIColor getColor:@"363636"];
    descLabel.backgroundColor=[UIColor clearColor];
    descLabel.font=[UIFont systemFontOfSize:14];
    descLabel.textAlignment=UITextAlignmentRight;
    descLabel.text=@"";
    [cell.contentView addSubview:descLabel];
    
    if(indexPath.section==0){
      
      if(indexPath.row==0){
        cell.textLabel.text=@"拍照设置";
        
        if(_count>0){
          descLabel.text=[NSString stringWithFormat:@"未上传(%d张)",_count];
        }
      }else{
        
#ifdef isProVersion
        cell.textLabel.text=@"天气服务(专业版用户无需购买)";
#else
        cell.textLabel.text=@"天气服务";
#endif
        UserPay *userPay=[_userPays objectForKey:INT2NUM(UserPay_Weather)];
        if(userPay!=nil){
          if(userPay.status==UserPayStatus_Try||userPay.status==UserPayStatus_Valid){
            descLabel.text=[NSString stringWithFormat:@"剩余%d天",userPay.extdatelong];
          }else if(userPay.status==UserPayStatus_Invalid){
            descLabel.text=@"已过期";
          }
        }
      }
    }else if(indexPath.section==1){
      if(indexPath.row==0){
        cell.textLabel.text=@"新用户指南";
        
      }else if(indexPath.row==1){
        cell.textLabel.text=@"评价骑行者";
        
      }else if(indexPath.row==2){
        
        cell.textLabel.text=@"骑行者反馈";
      }else{
        cell.textLabel.text=@"查看新版本";
      }
    }else if(indexPath.section==2){
      
      if(indexPath.row==0){
        cell.textLabel.text=@"推荐给骑友";
      }
    }
      return cell;
  }else{
    
    if(indexPath.row==0){
      UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier: @"btnIdentifier"];
      cell.selectionStyle=UITableViewCellSelectionStyleNone;
      cell.backgroundColor=[UIColor clearColor];
      cell.backgroundView=[[UIView alloc]init];
      UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
      [cell.contentView addSubview:btn];
      
      btn.frame=CGRectMake(20, 0, 258, 34);
      [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
      if ([[RiddingAppDelegate shareDelegate] canLogin]) {
        [btn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_system_logout") forState:UIControlStateNormal];
        [btn setTitle:@"退出" forState:UIControlStateNormal];

      } else {
        [btn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_system_login") forState:UIControlStateNormal];
        [btn setTitle:@"登录" forState:UIControlStateNormal];
      }
      return cell;
    }
  }
  return nil;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  if(indexPath.section==0){
    if(indexPath.row==0){
      
      PhotoSyncViewController *photoSync=[[PhotoSyncViewController alloc]initWithCount:_count];
      [self.navigationController pushViewController:photoSync animated:YES];
    }else{
      [self updateToVIP];
    }
  }else if(indexPath.section==1){
    if(indexPath.row==0){
      
      UserHelpViewController *helpController=[[UserHelpViewController alloc]init];
      [self.navigationController pushViewController:helpController animated:YES];
      
    }else if(indexPath.row==1){
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkAppStoreComment]];
      
    }else if(indexPath.row==2){
      [MobClick event:@"2013031907"];
      FeedBackViewController *feedBackViewController=[[FeedBackViewController alloc]init:FALSE];
      [self.navigationController pushViewController:feedBackViewController animated:YES];
    }else{
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkAppStore]];
    }
  }else if(indexPath.section==2){
    
    if(indexPath.row==0){
      [self showShare];
    }
  }else{
    
    if(indexPath.row==0){
     
      
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
  
  
  if ([[RiddingAppDelegate shareDelegate] canLogin]) {
    UserPay *userPay=[_userPays objectForKey:INT2NUM(UserPay_Weather)];
    VipViewController *vipView=[[VipViewController alloc]initWithUserPay:userPay];
    [self.navigationController pushViewController:vipView animated:YES];

//    VipSettingViewController *vipSetting=[[VipSettingViewController alloc]init];
//    [self.navigationController pushViewController:vipSetting animated:YES];
  } else {
    [self presentLoginView];
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


- (void)btnClick:(id)sender{
  
  if ([[RiddingAppDelegate shareDelegate] canLogin]) {
    [self quitButtonClick];
  } else {
    [self presentLoginView];
  }
}

- (void)showShare {
  
  if([MFMessageComposeViewController canSendText]){
		[MobClick event:@"2013022101"];
    MFMessageComposeViewController *smsComposer = [[MFMessageComposeViewController alloc] init];
		
    smsComposer.body = [NSString stringWithFormat:@"我下载了一款骑行应用叫\"骑行者\",非常不错！以后出去骑车就靠它了。可以画路线,添加队友,追踪队友位置,还能拍照记录行程。赶紧下一个去!给你链接:%@",linkAppStore];
    smsComposer.messageComposeDelegate = self;
		
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
  if(result==MessageComposeResultSent){
    [MobClick event:@"2013022102"];
  }
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - MapCreateDescVCTL delegate
- (void)succUploadPicture:(NSNotification *)note {
  
    _count= [RiddingPictureDao getRiddingPictureCount];
    [self.uiTableView reloadData];
  
}
@end
