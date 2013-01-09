//
//  MPDatePicker.m
//  Phamily
//
//  Created by zys on 12-10-29.
//  Copyright (c) 2013年 zyslovely@gmail.com. All rights reserved.
//

#import "QQNRDatePicker.h"
#define DATEPICKER_HEIGHT 235
#define TOOLBAR_HEIGHT 44
@implementation QQNRDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self initDatePicker];
      [self initToolBar];
      [self showDatePicker];
    }
    return self;
}

- (void)initDatePicker{
  
  UIDatePicker *picker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, TOOLBAR_HEIGHT, self.frame.size.width, DATEPICKER_HEIGHT)];
  self.datePicker=picker;
  [self addSubview:self.datePicker];
}

- (void)initToolBar{
  
  _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,TOOLBAR_HEIGHT )];
  [_toolBar setTintColor:kColor_pickerViewBarTint];
  
  UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
  UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(ok:)];
  UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
  NSMutableArray *items = [[NSMutableArray alloc] init];
  [items addObject:leftItem];
  [items addObject:spaceItem];
  [items addObject:rightItem];
  [_toolBar setItems:items];
  [self addSubview:_toolBar];
  
}

#pragma mark - datePicker
- (void)showDatePicker{
  if(_datePickerIsShowing){
    return;
  }
  CGRect frame=CGRectMake(0, SCREEN_HEIGHT-DEFAULT_HEIGHT, self.frame.size.width, DEFAULT_HEIGHT);
  if(self){
    [UIView animateWithDuration:0.3
                     animations:^{
                       self.frame = frame;
                     }];
    _datePickerIsShowing=TRUE;
  }
  
}

- (void)hideDatePicker{
  if(!_datePickerIsShowing){
    return ;
  }
  CGRect frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, DEFAULT_HEIGHT);
  if(self){
    [UIView animateWithDuration:0.3
                     animations:^{
                       self.frame = frame;
                     }];
    _datePickerIsShowing=FALSE;
  }
}

- (void)ok:(id)sender{
  if(self.delegate!=nil){
    NSDate *date_one = _datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日hh:mm分"];
    [self.delegate didFinishChoice:[formatter stringFromDate:date_one]];
  }
  [self hideDatePicker];
}

- (void)cancel:(id)sender{
  [self hideDatePicker];
}


@end
