//
//  BasicLeftFootView.h
//  Ridding
//
//  Created by zys on 13-1-22.
//
//

#import <UIKit/UIKit.h>
@class BasicLeftFootView;
@protocol BasicLeftFootViewDelegate <NSObject>

@optional
- (void)settingBtnClick;

- (void)avatorBtnClick;

@end
@interface BasicLeftFootView : UIView

@property (nonatomic,assign) id<BasicLeftFootViewDelegate> delegate;

- (void)setUser;
@end
