//
//  BasicLeftFootView.m
//  Ridding
//
//  Created by zys on 13-1-22.
//
//

#import "StaticInfo.h"
#import "UIButton+WebCache.h"
#import "QiNiuUtils.h"

@interface BasicLeftFootView () {
  UIButton *_avatorBtn;
  UILabel *_nameLabel;
}
@end

@implementation BasicLeftFootView

- (id)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (self) {
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
    lineView.image = [UIIMAGE_FROMPNG(@"qqnr_ln_sepator") stretchableImageWithLeftCapWidth:2 topCapHeight:0];
    [self addSubview:lineView];

    [self setUser];

    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(200, 7, 52, 52);
    [settingBtn setImage:UIIMAGE_FROMPNG(@"qqnr_ln_setting") forState:UIControlStateNormal];
    [settingBtn setImage:UIIMAGE_FROMPNG(@"qqnr_ln_setting_hl") forState:UIControlStateHighlighted];
    [settingBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.showsTouchWhenHighlighted = YES;
    [self addSubview:settingBtn];
  }
  return self;
}

- (void)settingBtnClick:(id)selector {

  if (self.delegate) {
    [self.delegate settingBtnClick];
  }
}

- (void)setUser {

  User *user = [StaticInfo getSinglton].user;
  if (user.userId > 0) {
    if (!_avatorBtn) {
      _avatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      _avatorBtn.frame = CGRectMake(30, 15, 30, 30);
      [_avatorBtn addTarget:self action:@selector(avatorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:_avatorBtn];
    }

    NSURL *url = [QiNiuUtils getUrlBySizeToUrl:_avatorBtn.frame.size url:user.savatorUrl type:QINIUMODE_DESHORT];
    [_avatorBtn setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
    if (!_nameLabel) {
      _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 100, 30)];
      _nameLabel.textColor = [UIColor whiteColor];
      _nameLabel.backgroundColor = [UIColor clearColor];
      _nameLabel.textAlignment = UITextAlignmentLeft;
      _nameLabel.font = [UIFont systemFontOfSize:20];
      [self addSubview:_nameLabel];

    }
    _nameLabel.text = user.name;
  }
}

- (void)resetUser {

  [_avatorBtn setImage:nil forState:UIControlStateNormal];
  [_avatorBtn setImage:nil forState:UIControlStateHighlighted];
  _nameLabel.text = @"";
}

- (void)avatorBtnClick:(id)selector {

  if (self.delegate) {
    [self.delegate avatorBtnClick];
  }
}

@end
