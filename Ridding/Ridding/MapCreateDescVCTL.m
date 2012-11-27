//
//  MapCreateDescVCTL.m
//  Ridding
//
//  Created by zys on 12-11-17.
//
//

#import "MapCreateDescVCTL.h"
#import "RequestUtil.h"
#import "UIColor+XMin.h"
#import "UIImage+Utilities.h"
#import "SinaApiRequestUtil.h"
#import "StaticInfo.h"
@interface MapCreateDescVCTL ()

@end

@implementation MapCreateDescVCTL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil info:(MapCreateInfo*)info
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _createInfo=info;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initHUD];
  
  [self.barView.rightButton setTitle:@"确定" forState:UIControlStateNormal];
  [self.barView.rightButton setTitle:@"确定" forState:UIControlStateHighlighted];
  [self.barView.rightButton setHidden:NO];
  
  self.barView.titleLabel.text=@"创建活动";
  self.beginLocationLB.textColor=[UIColor getColor:@"666666"];
  self.endLocationLB.textColor=[UIColor getColor:@"666666"];
  self.nameField.textColor=[UIColor getColor:@"666666"];
  self.totalDistanceLB.textColor=[UIColor getColor:@"666666"];
  self.beginLocationLB.text=[NSString stringWithFormat:@"%@",_createInfo.beginLocation];
  self.endLocationLB.text=[NSString stringWithFormat:@"%@",_createInfo.endLocation];
  self.totalDistanceLB.text=[NSString stringWithFormat:@"总行程:%0.2fKM",_createInfo.distance*1.0/1000];
  
  self.nameField.returnKeyType=UIReturnKeyGo;
  self.mapImageView.image=_createInfo.coverImage;
  self.view.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"bg_dt")];
  
  _redSC= [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不分享", @"分享", nil]];
  [_redSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
  _redSC.crossFadeLabelsOnDrag = YES;
  _redSC.thumb.tintColor = [UIColor getColor:ColorBlue];
  _redSC.selectedIndex = 1;
  [self.view addSubview:_redSC];
  _redSC.center = CGPointMake(240,355);
  _sendWeiBo=TRUE;
  
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)rightBtnClicked:(id)sender{
  [MobClick event:@"2012111903"];
  self.barView.rightButton.enabled=NO;
  [_HUD show:YES];
  if([self.nameField.text isEqualToString:@""]||[self.nameField.text isEqualToString:@"添加活动名称"]){
    _HUD.mode = MBProgressHUDModeText;
    _HUD.labelText = @"去添加下活动名称咯~";
    _HUD.margin = 5.f;
    [_HUD hide:YES afterDelay:2];
    self.barView.rightButton.enabled=YES;
    return;
  }
  _createInfo.riddingName=self.nameField.text;
  NSDictionary *dic= [[RequestUtil getSinglton] addRidding:_createInfo];
  if([[dic objectForKey:@"code"]intValue]==200){
    if(_sendWeiBo){
      NSString *status=[NSString stringWithFormat:@"我刚刚用#骑行者#创建了一个骑行活动:%@,推荐给大家。链接:http://qiqunar.com.cn/user/%@/ridding/%@/ @骑去哪儿网 http://qiqunar.com.cn 下载地址:%@",_createInfo.riddingName,[StaticInfo getSinglton].user.userId,[dic objectForKey:@"riddingId"],downLoadPath];
      [[SinaApiRequestUtil getSinglton] sendCreateRidding:status url:[dic objectForKey:@"imageUrl"]];
    }else{
      [MobClick event:@"2012111905"];
    }
  }
  if(self.delegate){
    [self.delegate finishCreate:self];
  }
  self.barView.rightButton.enabled=YES;
  [_HUD hide:YES];
}

-(void)leftBtnClicked:(id)sender
{
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  [self.nameField setText:@""];
  return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
  [textField resignFirstResponder];
}
-(IBAction)viewClick:(id)sender{
  UIView *view=(UIView*)sender;
  if(view!=self.nameField){
    [self.nameField resignFirstResponder];
  }
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  NSMutableString *text = [textField.text mutableCopy];
  [text replaceCharactersInRange:range withString:string];
  return [text length] <= 12;
}

#pragma mark -
#pragma mark SPSegmentedControl
- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
  if(segmentedControl.selectedIndex==0){
    _sendWeiBo=FALSE;
  }else if(segmentedControl.selectedIndex==1){
    _sendWeiBo=TRUE;
  }
}


@end
