//
//  PublicViewCell.h
//  Ridding
//
//  Created by zys on 12-12-2.
//
//

#import <UIKit/UIKit.h>
#import "ActivityInfo.h"
@interface PublicViewCell : UITableViewCell{
  
}


@property (nonatomic,retain) IBOutlet UIImageView *firstPicImageView;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;
@property (nonatomic,retain) IBOutlet UILabel *distanceLabel;

@property (nonatomic,retain) ActivityInfo *info;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier info:(ActivityInfo*)info;

@end
