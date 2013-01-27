//
//  MPImagePickerVCTL.h
//  Phamily
//
//  Created by zys on 12-10-30.
//  Copyright (c) 2012年 儒果网络. All rights reserved.
//  重构的UIImagePicker,实现图片的多选功能
//

#import <UIKit/UIKit.h>
#import "MPToolbarViewController.h"
#import "MPPhotosBarView.h"

@class MPImagePickerVCTL;

@protocol MPImagePickerDelegate <NSObject>

- (void)saveBtnClick:(UIViewController *)view imagePickerInfos:(NSDictionary *)imagePickerInfos;

@optional

@end

@interface MPImagePickerVCTL : MPToolbarViewController <MPPhotosBarViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  MPPhotosBarView *_photoScrollView;
  UINavigationController *_pickerNavController;
  UIImagePickerController *_pickerController;
  int _viewIndex;
  BOOL _isBackAction;
}

@property (nonatomic, assign) id <MPImagePickerDelegate> delegate;

@end
