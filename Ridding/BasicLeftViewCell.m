//
//  BasicLeftViewCell.m
//  Ridding
//
//  Created by zys on 13-1-22.
//
//

#import "BasicLeftViewCell.h"
#import "UIColor+XMin.h"

@implementation BasicLeftViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {

  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)selected {

  self.leftColorView.backgroundColor = [UIColor getColor:ColorGreen];
  self.backgroundColorView.image = [UIIMAGE_FROMPNG(@"qqnr_ln_selected") stretchableImageWithLeftCapWidth:50 topCapHeight:20];
}

- (void)disSelected {

  self.leftColorView.backgroundColor = [UIColor clearColor];
  self.backgroundColorView.image = nil;
}

@end
