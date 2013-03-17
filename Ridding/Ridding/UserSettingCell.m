//
//  UserSettingCell.m
//  Ridding
//
//  Created by zys on 13-2-20.
//
//

#import "UserSettingCell.h"
#import "UIColor+XMin.h"
@implementation UserSettingCell

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

- (void)initView:(NSString*)text{
  
  self.textLabel.text=text;
}

@end
