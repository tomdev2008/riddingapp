//
//  FeedBackViewController.m
//  Ridding
//
//  Created by zys on 13-3-7.
//
//

#import "FeedBackViewController.h"
#import "NSString+Addition.h"

#import "SVProgressHUD.h"
#import "Utilities.h"
#import "UIColor+XMin.h"
@interface FeedBackViewController ()

@end

@implementation FeedBackViewController


- (id)init:(BOOL)fromLeft{
  self=[super init];
  if(self){
    _isFromLeft=fromLeft;
  }
  return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor=[UIColor getColor:@"dbdbd3"];
  _textView.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_feedback_content")];
 
  if(_isFromLeft){
    self.canMoveLeft=YES;
    self.hasLeftView = TRUE;
    [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list") forState:UIControlStateNormal];
    [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list_hl") forState:UIControlStateHighlighted];
  }else{
    [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
    [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  }
  _qqField.textColor=[UIColor getColor:@"bdbdbd"];
  _emailField.textColor=[UIColor getColor:@"bdbdbd"];
  [self.barView.leftButton setHidden:NO];

  [self.barView.titleLabel setText:@"意见反馈"];
  
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
  
  [textView resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
  
  if([_textView.text isEqualToString:@"您好，有什么可以帮到您? ^_^"]){
    _textView.text=@"";
  }
[self viewDown];
  return TRUE;
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  [self viewDown];
  [textField resignFirstResponder];
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  
  if(textField==_qqField&&[_qqField.text isEqualToString:@"联系方式(QQ)"]){
    _qqField.text=@"";
  }
  if(textField==_emailField&&[_emailField.text isEqualToString:@"联系方式(Email)"]){
    _emailField.text=@"";
  }
  
  [self viewUp];
  return YES;
}

- (void)viewUp{
  
  if(self.view.frame.origin.y==0){
    [UIView animateWithDuration:0.2 animations:^{
      CGRect frame=self.view.frame;
      frame.origin.y-=100;
      self.view.frame=frame;
    }];
  }
}

- (void)viewDown{
  
  if(self.view.frame.origin.y<0){
    [UIView animateWithDuration:0.2 animations:^{
      CGRect frame=self.view.frame;
      frame.origin.y+=100;
      self.view.frame=frame;
    }];
  }
}


-(IBAction)sendBtnClick:(id)sender{
  
  if([_textView.text isEqualToString:@"您好，有什么可以帮到您? ^_^"]||[_textView.text isEqualToString:@""]){
    [SVProgressHUD showErrorWithStatus:@"请填写反馈的内容" duration:1.0];
    return;
  }
  if(![_qqField.text isEqualToString:@""]&&![_qqField.text isEqualToString:@"联系方式(QQ)"]){
    if(![_qqField.text isPureLong]){
      [SVProgressHUD showErrorWithStatus:@"请填写正确的qq号" duration:1.0];
      return;
    }
  }
  if(![_emailField.text isEqualToString:@""]&&![_emailField.text isEqualToString:@"联系方式(Email)"]){
    if(![_emailField.text isEmail]){
      [SVProgressHUD showErrorWithStatus:@"请填写正确的email" duration:1.0];
      return;
    }
  }
  if([_qqField.text isEqualToString:@"联系方式(QQ)"]){
    _qqField.text=@"";
  }
  if([_emailField.text isEqualToString:@"联系方式(Email)"]){
    _emailField.text=@"";
  }
 
  NSString *appVersion=[Utilities appVersion];
  CGFloat iosVersion=[Utilities deviceVersion];
  NSString *deviceVersion=[Utilities getDeviceVersion];
  [self.requestUtil feedBack:appVersion iosVersion:[NSString stringWithFormat:@"%f",iosVersion] deviceVersion:deviceVersion userQQ:_qqField.text userEmail:_emailField.text description:_textView.text];
  [SVProgressHUD showSuccessWithStatus:@"发送成功" duration:1.0];
}

- (IBAction)otherViewClick:(id)sender{
  UIView *view=(UIView*)sender;
  if(view!=_textView&&view!=_qqField&&view!=_emailField){
    [_textView resignFirstResponder];
    [_qqField resignFirstResponder];
    [_emailField resignFirstResponder];
  }
  [self viewDown];
}
@end
