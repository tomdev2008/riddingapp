//
//  MPDatePicker.h
//  Phamily
//
//  Created by zys on 12-10-29.
//  Copyright (c) 2013年 zyslovely@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_HEIGHT 260

@protocol QQNRDatePickerDelegate <NSObject>

- (void)didFinishChoice:(NSString *)dateStr;

@end

@interface QQNRDatePicker : UIControl {
  UIToolbar *_toolBar;
  BOOL _datePickerIsShowing;
}

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, assign) id <QQNRDatePickerDelegate> delegate;

- (void)showDatePicker;

- (void)hideDatePicker;
@end
