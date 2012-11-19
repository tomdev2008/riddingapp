//
//  PhotoUploadBlurView.h
//  Ridding
//
//  Created by zys on 12-10-27.
//
//

#import <UIKit/UIKit.h>
#import "YLProgressBar.h"
#import "SWSnapshotStackView.h"
@interface PhotoUploadBlurView : UIView{
  SWSnapshotStackView *_imageView;
  YLProgressBar *_progressBar;
  UILabel *_label;
}
- (void)setValue:(UIImage*)image text:(NSString*)text value:(float)value;
@end
