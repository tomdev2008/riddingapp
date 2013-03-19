//
//  VipSettingViewController.m
//  Ridding
//
//  Created by zys on 13-3-15.
//
//

#import "VipSettingViewController.h"
#import "UserSettingCell.h"
#import "UserPay.h"
#import "Utilities.h"
#import "VipViewController.h"
@interface VipSettingViewController ()

@end

@implementation VipSettingViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  
  [self.barView.titleLabel setText:@"高级功能"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  self.uiTableView.backgroundColor=[UIColor clearColor];
  _userPays=[[NSMutableDictionary alloc]init];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if(!self.didAppearOnce){
    self.didAppearOnce=YES;
    NSArray *array=[self.requestUtil getUserPays:-1];
    NSLog(@"%d",[array count]);
    if(array){
      for(NSDictionary *dic in array){
        UserPay *userPay=[[UserPay alloc]initWithJSONDic:[dic objectForKey:keyUserPay]];
        [_userPays setObject:userPay forKey:INT2NUM(userPay.type)];
      }
    }
    [self.uiTableView reloadData];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  
  cell.textLabel.font=[UIFont systemFontOfSize:14];
  cell.textLabel.textAlignment=UITextAlignmentLeft;
  cell.textLabel.textColor=[UIColor whiteColor];
  cell.selectionStyle=UITableViewCellSelectionStyleNone;
  if ([indexPath row] == 0) {
    cell.textLabel.text=@"天气服务";
    UserPay *userPay=[_userPays objectForKey:INT2NUM(UserPay_Weather)];
    UILabel *countLabel=[[UILabel alloc]initWithFrame:CGRectMake(180, 18, 140, 20)];
    countLabel.textColor=[UIColor whiteColor];
    countLabel.backgroundColor=[UIColor clearColor];
    countLabel.font=[UIFont systemFontOfSize:14];
    [cell.contentView addSubview:countLabel];
    if(userPay==nil){
      countLabel.text=@"未购买";
    }else if(userPay.status==UserPayStatus_Try){
      countLabel.text=[NSString stringWithFormat:@"试用期,剩余%d天",userPay.extdatelong];
    }else if(userPay.status==UserPayStatus_Invalid){
      countLabel.text=@"已过期";
    }else if(userPay.status==UserPayStatus_Valid){
      countLabel.text=[NSString stringWithFormat:@"剩余%d天",userPay.extdatelong];
    }
    
  } else if ([indexPath row] == 1) {
    cell.textLabel.text=@"支持我们";
  }
  return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([indexPath row] == 0) {
    UserPay *userPay=[_userPays objectForKey:INT2NUM(UserPay_Weather)];
    VipViewController *vipView=[[VipViewController alloc]initWithUserPay:userPay];
    [self.navigationController pushViewController:vipView animated:YES];

  } else if ([indexPath row] == 1) {
    NSURL *url = [NSURL URLWithString:online_taobao_link_weather];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
      [[UIApplication sharedApplication] openURL:url];
    } else {
      url = [NSURL URLWithString:online_taobao_url_weather];
      [[UIApplication sharedApplication] openURL:url];
    }
  }
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

@end
