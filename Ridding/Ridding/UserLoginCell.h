//
//  UserLoginCell.h
//  Ridding
//
//  Created by zys on 13-2-20.
//
//

#import <UIKit/UIKit.h>
@class UserLoginCell;
@protocol UserLoginCellDelegate <NSObject>

- (void)btnClick:(UserLoginCell*)cell;

@end


@interface UserLoginCell : UITableViewCell


@property (nonatomic,retain) IBOutlet UIButton *loginBtn;
@property (nonatomic,assign) id<UserLoginCellDelegate> delegate;

- (void)initView:(BOOL)login;
@end
