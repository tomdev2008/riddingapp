//
//  MBTouchZoomImageView.h
//  MMBang
//
//  Created by Tom 陈剑飞 on 4/10/12.
//  Copyright (c) 2012 骑去哪儿网. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBImageView_touchDisabled;
@class MBTouchZoomImageView;

@protocol MBTouchZoomImageViewDelegate <NSObject>

@optional
- (void)touchZoomImageViewDidDisappear:(MBTouchZoomImageView *)imageView;
@end

@interface MBTouchZoomImageView : UIView <UIActionSheetDelegate, UIScrollViewDelegate> {
  
  UIView      *_maskView;
  CGRect      originalFrame;
  BOOL        didRotationAnimation;
  UIImage     *_imageToSave;
  
  UIImageView               *_imageView;
  UIScrollView              *_scrollview;
}

@property (nonatomic, assign) id<MBTouchZoomImageViewDelegate> delegate;

- (id)init;
- (void)showFromFrame:(CGRect)aOriginalFrame withImage:(UIImage *)image;
- (void)showActionSheetToSaveImage:(UIImage *)imageToSave;

@end
