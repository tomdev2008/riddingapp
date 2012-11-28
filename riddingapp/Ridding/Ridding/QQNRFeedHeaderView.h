//
//  QQNRFeedHeaderView.h
//  Ridding
//
//  Created by zys on 12-9-27.
//
//

#import <UIKit/UIKit.h>
#import "User.h"
@protocol QQNRFeedHeaderViewDelegate <NSObject>

@end

@interface QQNRFeedHeaderView : UIView{
  UILabel *_mileStone;
}

@property (nonatomic, assign) id<QQNRFeedHeaderViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame user:(User*)user;
@end
