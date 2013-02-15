//
//  NearByUserCell.h
//  Ridding
//
//  Created by zys on 13-2-8.
//
//

#import <UIKit/UIKit.h>

@interface NearByUserCell : UITableViewCell{
  
}


@property (nonatomic,retain) IBOutlet UIButton *avatorBtn;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic) int index;

@end
