//
//  MBTouchZoomImageView.m
//  MMBang
//
//  Created by Tom 陈剑飞 on 4/10/12.
//  Copyright (c) 2012 骑去哪儿网. All rights reserved.
//  会判断图片长宽，用于判断横向还是纵向

#import "MBTouchZoomImageView.h"
#import "MBImageView_touchDisabled.h"
#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation MBTouchZoomImageView

@synthesize delegate   = _delegate;

- (void)layoutScrollview {
  
  // center the image as it becomes smaller than the size of the screen
  
  CGSize boundsSize     = _scrollview.bounds.size;
  CGRect frameToCenter  = _imageView.frame;
  
  // center horizontally
  if (frameToCenter.size.width < boundsSize.width)
    frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
  else
    frameToCenter.origin.x = 0;
  
  // center vertically
  if (frameToCenter.size.height < boundsSize.height)
    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
  else
    frameToCenter.origin.y = 0;
  
  _imageView.frame = frameToCenter;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
      
      _scrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
      _scrollview.showsVerticalScrollIndicator = NO;
      _scrollview.showsHorizontalScrollIndicator = NO;
      _scrollview.bouncesZoom = YES;
      _scrollview.decelerationRate = UIScrollViewDecelerationRateFast;
      _scrollview.delegate = self;
      _scrollview.zoomScale = 1.0;
      _scrollview.minimumZoomScale = 0.5;
      _scrollview.maximumZoomScale = 2.0;
      _scrollview.contentSize = self.bounds.size;
      _scrollview.multipleTouchEnabled = YES;
      
      [self addSubview:_scrollview];
      
      
      _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
      _imageView.userInteractionEnabled = YES;
      _imageView.contentMode = UIViewContentModeScaleAspectFit;
      [_scrollview addSubview:_imageView];
      
      [self setHidden:YES];
      
      
      
      UITapGestureRecognizer*aUiTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePress:)];
      [aUiTap setNumberOfTapsRequired:1];
      [aUiTap setNumberOfTouchesRequired:1];
      
      UILongPressGestureRecognizer* aUiLongpressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
      
      aUiLongpressGesture.allowableMovement = 10;
      aUiLongpressGesture.cancelsTouchesInView = NO;
      aUiLongpressGesture.delaysTouchesBegan = NO;
      
      [_imageView addGestureRecognizer:aUiTap];
      [_imageView addGestureRecognizer:aUiLongpressGesture];
      
      [aUiTap release];
      [aUiLongpressGesture release];  
    }
    return self;
}

- (id)init{
  
  self = [self initWithFrame:CGRectMake(0, 0.0, 320, SCREEN_HEIGHT)];
  if (self) {
    
  }
  
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)showFromFrame:(CGRect)aOriginalFrame withImage:(UIImage *)image {
  
  
  UIWindow* window = [UIApplication sharedApplication].keyWindow;
  if (!window) {
    window = [[UIApplication sharedApplication].windows objectAtIndex:0];
  }
  
  
  if (!_maskView) {
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, 320, SCREEN_HEIGHT)];
    _maskView.backgroundColor = [UIColor blackColor];

  }

  [window addSubview:self];
  [window insertSubview:_maskView belowSubview:self];

	didRotationAnimation = NO;
  originalFrame = aOriginalFrame;

  [_imageView setImage:image];  
  [_imageView setFrame:originalFrame];
  
  _scrollview.zoomScale = 1.0;  
  _scrollview.contentOffset = CGPointZero;
  _scrollview.contentInset = UIEdgeInsetsZero;  
  [_scrollview setContentSize:self.bounds.size];

  
  [self setHidden:NO];

  //。。。旋转横图
  if (aOriginalFrame.size.width > aOriginalFrame.size.height) 
  {
		// animation
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		[UIView beginAnimations:nil context:context]; 
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
		[UIView setAnimationDuration:0.3f]; 
		
		[CATransaction begin];
    _imageView.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 90.0f, 0.0f, 0.0f, 1.0f);	
		[CATransaction commit];
		
		[_imageView setFrame:CGRectMake(0.0, 0.0, 320.0, SCREEN_HEIGHT)];
		
		[UIView commitAnimations];
		
		didRotationAnimation = YES;
    
  }else {
		// animation
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		[UIView beginAnimations:nil context:context]; 
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
		[UIView setAnimationDuration:0.3f]; 
		
		[_imageView setFrame:CGRectMake(0.0, 0.0, 320.0, SCREEN_HEIGHT)];
		
		[UIView commitAnimations];		
	}

  [UIApplication sharedApplication].statusBarHidden=YES;
}

- (void)hide {

  [_maskView removeFromSuperview];
  if(_maskView){
    [_maskView release];
  }
  
  [self setHidden:YES];
  
  if (_delegate && [_delegate respondsToSelector:@selector(touchZoomImageViewDidDisappear:)]) {
    [_delegate touchZoomImageViewDidDisappear:self];
  }
  
  [UIApplication sharedApplication].statusBarHidden=NO;  
}

- (void)showActionSheetToSaveImage:(UIImage *)imageToSave {
  
  _imageToSave = imageToSave;
  
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存照片",nil];
  [actionSheet showInView:self.superview];
  [actionSheet release];  
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
  
  if (UIGestureRecognizerStateBegan != gesture.state) {
    return;
  }
  
  [self showActionSheetToSaveImage:_imageView.image];
}

- (void)handlePress:(id)sender {
  
  [UIView animateWithDuration:0.3f animations:^{
		
		if (didRotationAnimation) {
			
			[CATransaction begin];
			_imageView.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 0.0f, 0.0f, 0.0f, 1.0f);	
			[CATransaction commit];
		}
		
    if (_imageView.frame.size.height >self.bounds.size.height) {
      // is zooming
      _scrollview.zoomScale = 1.0;   
    }
    
    [_imageView setFrame:originalFrame];   		
  } completion:^(BOOL finished){
    [self hide];
  }];
}

- (void)dealloc {
  
  [_maskView    release];
  [_imageView   release];
  [_scrollview  release];
  
  [super dealloc];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
  if (buttonIndex==0) {
		
    UIImageWriteToSavedPhotosAlbum(_imageToSave,nil,nil,nil);
//    [Utilities alertInstant:@"成功保存到本地相册中" isError:NO];
  }
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return _imageView;
}

@end
