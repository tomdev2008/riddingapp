//
//  QQNRFeedHeaderView.h
//  Ridding
//
//  Created by zys on 12-9-27.
//
//

#import <UIKit/UIKit.h>
#import "User.h"

#define QQNRFeedHeaderView_Default_Height 180
@class QQNRFeedHeaderView;
@protocol QQNRFeedHeaderViewDelegate <NSObject>

- (void)backGroupViewClick:(QQNRFeedHeaderView*)view;

@end

@interface QQNRFeedHeaderView : UIView{
  UILabel *_mileStone;
  UIButton *_relationBtn;
}

@property (nonatomic, assign) id<QQNRFeedHeaderViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame user:(User*)user;
- (void)finishRidding;
@end
