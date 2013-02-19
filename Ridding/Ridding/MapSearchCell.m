//
//  MapSearchCell.m
//  Ridding
//
//  Created by zys on 13-2-19.
//
//

#import "MapSearchCell.h"

@implementation MapSearchCell

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

- (void)initView:(NSString*)location{
  _locationLabel.text=location;
}

@end
