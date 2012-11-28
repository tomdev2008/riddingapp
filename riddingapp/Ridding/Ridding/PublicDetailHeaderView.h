//
//  PublicDetailHeaderView.h
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import <UIKit/UIKit.h>
#import "ActivityInfo.h"
@protocol PublicDetailHeaderDelegate <NSObject>

@end

@interface PublicDetailHeaderView : UIView{
  ActivityInfo *_info;
  
}

@property (nonatomic, assign) id<PublicDetailHeaderDelegate> delegate;

- (id)initWithFrame:(CGRect)frame info:(ActivityInfo*)info;
@end
