//
//  UserLoginCell.m
//  Ridding
//
//  Created by zys on 13-2-20.
//
//

#import "UserLoginCell.h"

@implementation UserLoginCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClick:(id)sender{
  if(self.delegate){
    [self.delegate btnClick:self];
  }
}


- (void)initView:(BOOL)login{
  if(login){
    [self.loginBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_system_login") forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
  }else{
    [self.loginBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_system_logout") forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"退出" forState:UIControlStateNormal];
  }
}




@end
