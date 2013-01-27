//
//  MPImagePickerVCTL.m
//  Phamily
//
//  Created by zys on 12-10-30.
//  Copyright (c) 2012年 儒果网络. All rights reserved.
//

#import "MPImagePickerVCTL.h"
#import "MPImageServerTask.h"
#import "MPServerTaskQueue.h"
#import <ImageIO/ImageIO.h>

@interface MPImagePickerVCTL ()

@end

@implementation MPImagePickerVCTL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];
  _viewIndex = 0;
  //18是用于解决边界问题
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kAppToolbarHeight - 18, SCREEN_HEIGHT, SCREEN_HEIGHT_WITHOUT_STATUS_BAR- kAppToolbarHeight)];
  _pickerController = [[UIImagePickerController alloc] init];
  //86做heck
  _pickerController.view.frame = CGRectMake(_pickerController.view.frame.origin.x, _pickerController.view.frame.origin.y, _pickerController.view.frame.size.width, _pickerController.view.frame.size.height - 86);
  _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [_pickerController.navigationBar setHidden:YES];
  _pickerController.delegate = self;
  [view addSubview:_pickerController.view];
  [self.view addSubview:view];
  [view release];
  [self.view bringSubviewToFront:_basicToolbar];

}

- (void)basicConfirmButtonPressed:(id)sender {

  [self dismissModalViewControllerAnimated:YES];
}

- (void)basicCancelButtonPressed:(id)sender {

  _viewIndex--;
  _isBackAction = TRUE;
  [self dismissModalViewControllerAnimated:NO];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

  if (!_isBackAction) {
    _viewIndex++;
  }
  _isBackAction = FALSE;
  if (!_pickerNavController) {
    _pickerNavController = [navigationController retain];
  }
  //如果是第二个controller，显示选择器
  if (_viewIndex == 2) {
    if (!_photoScrollView) {
      _photoScrollView = [[MPPhotosBarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT_WITHOUT_STATUS_BAR, SCREEN_WIDTH, DEFAULTVIEW_WIDTH)];
      _photoScrollView.delegate = self;
      [self.view addSubview:_photoScrollView];
    }
    [_photoScrollView showView];
    [self.view bringSubviewToFront:_photoScrollView];
  } else {
    [_photoScrollView hideView];
  }

}

#pragma mark -
#pragma mark imagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

  @synchronized (self) {
    [_photoScrollView setScrollViewImage:info];
  }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

  NSLog(@"cancel");
}

#pragma mark -
#pragma mark MPPhotoViewDelegate
- (void)saveBtnClick:(MPPhotosBarView *)view imagePickerInfos:(NSDictionary *)imagePickerInfos {

  if (self.delegate) {
    [self.delegate saveBtnClick:self imagePickerInfos:imagePickerInfos];
  }
}


- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {

  SAFECHECK_RELEASE(_photoScrollView);
  SAFECHECK_RELEASE(_pickerNavController);
  SAFECHECK_RELEASE(_pickerController);
  [super viewDidUnload];
}

- (void)dealloc {

  [_photoScrollView release];
  [_pickerController release];
  [_pickerNavController release];
  self.delegate = nil;
  [super dealloc];
}

@end
