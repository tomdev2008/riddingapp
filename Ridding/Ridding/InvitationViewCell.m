//
//  InvitationViewCell.m
//  Ridding
//
//  Created by zys on 13-2-19.
//
//

#import "InvitationViewCell.h"
#import "QiNiuUtils.h"
#import "UIImageView+WebCache.h"
@implementation InvitationViewCell

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

- (void)awakeFromNib{
  self.separatorLine.image=[UIIMAGE_FROMPNG(@"qqnr_pd_comment_line") stretchableImageWithLeftCapWidth:17 topCapHeight:0];
  
  [super awakeFromNib];
}

- (void)initWithSinaUser:(SinaUserProfile*)profile index:(int)index{
  
  self.nameLabel.text=profile.screen_name;
  
  NSURL *url=[QiNiuUtils getUrlBySizeToUrl:self.avatorImageView.frame.size url:[profile avatorUrlStr] type:QINIUMODE_DESHORT];
  [self.avatorImageView setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
  
  if(profile.isSelected){
    [self.takeBtn setImage:UIIMAGE_FROMPNG(@"qqnr_map_addmember_icon_add1") forState:UIControlStateNormal];
  }else{
    [self.takeBtn setImage:UIIMAGE_FROMPNG(@"qqnr_map_addmember_icon_add_hl") forState:UIControlStateNormal];
  }
  self.index=index;
}

- (IBAction)checkBtnClick:(id)sender{
  
  if(self.delegate){
    [self.delegate checkBtnClick:self];
  }
  
}




@end
