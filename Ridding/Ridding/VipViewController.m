//
//  VipViewController.m
//  Ridding
//
//  Created by zys on 13-3-18.
//
//

#import "VipViewController.h"
#import "UIColor+XMin.h"
#import "SVProgressHUD.h"
#import "UserPay.h"
#import "PublicLinkWebViewController.h"
@interface VipViewController ()

@end

@implementation VipViewController

- (id)initWithUserPay:(UserPay*)userPay{
  self=[super init];
  if(self){
    _userPay=userPay;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  
  [self.barView.titleLabel setText:@"天气服务"];
  _scrollView.contentSize=CGSizeMake(0, 528);
  _taobaoCodeView.text=[StaticInfo getSinglton].user.taobaoCode;
  _taobaoCodeView.textColor=[UIColor whiteColor];//[UIColor getColor:@"786f74"];
  _taobaoCodeView.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_system_premium_code_bg")];
  _vipDescLabel.textColor=[UIColor getColor:@"e5e4e4"];
  _vipDescLabel.shadowColor=[UIColor getColor:@"2a3130"];
  _vipDescLabel.shadowOffset=CGSizeMake(0, -2);
  _dayLongLabel.textColor=[UIColor getColor:@"e5e4e4"];
  if(_userPay){
    _tryBtn.hidden=YES;
    _dayLongLabel.hidden=NO;
    [self resetDayLong];
  }else{
    _tryBtn.hidden=NO;
    _dayLongLabel.hidden=YES;
    
  }
  
  _descLabel.text=TaobaoCodeDesc;
  _descLabel.textColor=[UIColor getColor:@"8e8e8e"];
  _descLabel.numberOfLines=0;
  _descLabel.lineBreakMode=NSLineBreakByWordWrapping;
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];

}

- (void)resetDayLong{
  if(_userPay.status==UserPayStatus_Try){
    
    _dayLongLabel.text=[NSString stringWithFormat:@"试用中,剩余%d天",_userPay.extdatelong];
  }else if(_userPay.status==UserPayStatus_Invalid){
    
    _dayLongLabel.text=@"已过期";
  }else if(_userPay.status==UserPayStatus_Valid){
    
    _dayLongLabel.text=[NSString stringWithFormat:@"剩余%d天",_userPay.extdatelong];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tryBtnClick:(id)sender{
  [MobClick event:@"2013031903"];
  [SVProgressHUD showWithStatus:@"试用天气服务申请中，请稍后"];
  dispatch_queue_t q;
  q = dispatch_queue_create("tryBtnClickDisPatch", NULL);
  dispatch_async(q, ^{
    NSDictionary *dic=[self.requestUtil tryUserPay:UserPay_Weather];
    dispatch_async(dispatch_get_main_queue(), ^{
      if(dic){
        _userPay=[[UserPay alloc]initWithJSONDic:[dic objectForKey:keyUserPay]];
        if(_userPay){
          _tryBtn.hidden=YES;
          _dayLongLabel.hidden=NO;
          [self resetDayLong];
          [SVProgressHUD showSuccessWithStatus:@"恭喜,您已获得15天天气功能试用服务" duration:1.0];
        }
      }else{
        [SVProgressHUD dismiss];
      }
      
    });
  });
}

- (IBAction)copyAndBuy:(id)sender{
  
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  [pasteboard setString:[StaticInfo getSinglton].user.taobaoCode];
  [MobClick event:@"2013031902"];
  NSURL *url = [NSURL URLWithString:online_taobao_link_weather];
  if ([[UIApplication sharedApplication] canOpenURL:url]) {
   [MobClick event:@"2013031904"];
    [[UIApplication sharedApplication] openURL:url];
  
  } else {
    [MobClick event:@"2013031905"];
    PublicLinkWebViewController *linkWebVCTL=[[PublicLinkWebViewController alloc]initWithNibName:@"PublicLinkWebViewController" bundle:nil url:online_taobao_url_weather];
    [self.navigationController pushViewController:linkWebVCTL animated:YES];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if (scrollView.contentOffset.y < 0) {
    scrollView.contentOffset=CGPointMake(0, 0);
  }
}
@end
