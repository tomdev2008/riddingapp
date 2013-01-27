//
//  BasicLeftFootView.m
//  Ridding
//
//  Created by zys on 13-1-22.
//
//

#import "BasicLeftFootView.h"
#import "StaticInfo.h"
#import "UIButton+WebCache.h"
#import "User.h"
#import "QiNiuUtils.h"
@implementation BasicLeftFootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
      lineView.image=[UIIMAGE_FROMPNG(@"QQNR_LN_Sepator") stretchableImageWithLeftCapWidth:2 topCapHeight:0];
      [self addSubview:lineView];
      
      [self setUser];
      
      UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
      settingBtn.frame=CGRectMake(200, 17, 26, 26);
      [settingBtn setImage:UIIMAGE_FROMPNG(@"QQNR_LN_Setting") forState:UIControlStateNormal];
      [settingBtn setImage:UIIMAGE_FROMPNG(@"QQNR_LN_Setting") forState:UIControlStateHighlighted];
      [settingBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
      settingBtn.showsTouchWhenHighlighted=YES;
      [self addSubview:settingBtn];
    }
    return self;
}

- (void)settingBtnClick:(id)selector{
  if(self.delegate){
    [self.delegate settingBtnClick];
  }
}

- (void)setUser{
  User *user=[StaticInfo getSinglton].user;
  NSLog(@"%lld",user.userId);
  NSLog(@"%@",user.savatorUrl);
  if(user.userId>0){
    UIButton *avatorBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    avatorBtn.frame=CGRectMake(30, 15, 30, 30);
    NSURL *url=[QiNiuUtils getUrlBySizeToUrl:avatorBtn.frame.size url:user.savatorUrl type:QINIUMODE_DESHORT];
    [avatorBtn setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
    [avatorBtn addTarget:self action:@selector(avatorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:avatorBtn];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 15, 100, 30)];
    nameLabel.text=user.name;
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.textAlignment=UITextAlignmentLeft;
    nameLabel.font=[UIFont systemFontOfSize:20];
    [self addSubview:nameLabel];
  }
}

- (void)avatorBtnClick:(id)selector{
  if(self.delegate){
    [self.delegate avatorBtnClick];
  }
}

@end
