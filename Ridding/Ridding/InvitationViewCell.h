//
//  InvitationViewCell.h
//  Ridding
//
//  Created by zys on 13-2-19.
//
//

#import <UIKit/UIKit.h>
#import "SinaUserProfile.h"
@class InvitationViewCell;
@protocol InvitationViewCellDelegate <NSObject>

- (void)checkBtnClick:(InvitationViewCell*)cell;

@end

@interface InvitationViewCell : UITableViewCell


@property (nonatomic,retain) IBOutlet UIImageView *avatorImageView;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UIButton *takeBtn;
@property (nonatomic,retain) IBOutlet UIImageView *separatorLine;
@property (nonatomic,assign) id<InvitationViewCellDelegate> delegate;


@property (nonatomic) int index;

- (void)initWithSinaUser:(SinaUserProfile*)profile index:(int)index;
@end
