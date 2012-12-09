//
//  PublicDetailHeaderView.h
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import <UIKit/UIKit.h>
#import "Ridding.h"
@protocol PublicDetailHeaderDelegate <NSObject>

@end

@interface PublicDetailHeaderView : UIView{
  Ridding *_ridding;
  
}

@property (nonatomic, assign) id<PublicDetailHeaderDelegate> delegate;

- (id)initWithFrame:(CGRect)frame ridding:(Ridding*)ridding;
@end
