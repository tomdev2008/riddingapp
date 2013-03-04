//
//  UserSettingCell.h
//  Ridding
//
//  Created by zys on 13-2-20.
//
//

#import <UIKit/UIKit.h>

@interface UserSettingCell : UITableViewCell


@property (nonatomic,retain) IBOutlet UIImageView *separatorLine;
@property (nonatomic,retain) IBOutlet UILabel *textLabel;


- (void)initView:(NSString*)text;
@end
