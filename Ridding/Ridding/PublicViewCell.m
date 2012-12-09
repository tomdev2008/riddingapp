//
//  PublicViewCell.m
//  Ridding
//
//  Created by zys on 12-12-2.
//
//

#import "PublicViewCell.h"

@implementation PublicViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               info:(ActivityInfo*)info{
  
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _info=info;
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
