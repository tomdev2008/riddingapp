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
@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

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
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  [self.barView.titleLabel setText:@"意见反馈"];
  
  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create_disable") forState:UIControlStateNormal];
  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create_disable") forState:UIControlStateHighlighted];
  [self.barView.rightButton setEnabled:NO];
  [self.barView.rightButton setHidden:NO];

  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create_disable") forState:UIControlStateNormal];
  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create_disable") forState:UIControlStateHighlighted];
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
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
  
  if([_textView.text isEqualToString:@"给照片加段描述吧 ^_^"]||[_textView.text isEqualToString:@""]){
    [SVProgressHUD showErrorWithStatus:@"请填写反馈的内容" duration:1.0];
    return;
  }
  NSString *appVersion=[Utilities appVersion];
  CGFloat iosVersion=[Utilities deviceVersion];
  NSString *deviceVersion=[Utilities getDeviceVersion];
  [self.requestUtil feedBack:appVersion iosVersion:[NSString stringWithFormat:@"%f",iosVersion] deviceVersion:deviceVersion userQQ:_qqField.text userEmail:_emailField.text description:textView.text];
  
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
  
  if([_textView.text isEqualToString:@"给照片加段描述吧 ^_^"]){
    _textView.text=@"";
  }

  return TRUE;
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  
  
  return YES;
}
@end
