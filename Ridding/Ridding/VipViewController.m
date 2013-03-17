//
//  VipViewController.m
//  Ridding
//
//  Created by zys on 13-3-18.
//
//

#import "VipViewController.h"
#import "UIColor+XMin.h"
@interface VipViewController ()

@end

@implementation VipViewController

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
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  
  [self.barView.titleLabel setText:@"天气功能"];
  _scrollView.contentSize=CGSizeMake(0, 528);
  _taobaoCodeField.text=[StaticInfo getSinglton].user.taobaoCode;
  _taobaoCodeField.textColor=[UIColor getColor:@"786f74"];
  [_taobaoCodeField setEnabled:NO];
  
  _taobaoCodeField.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_system_premium_code_bg")];
  _descLabel.text=@"购买时,将淘宝码复制到“给卖家留言”即可";
  _descLabel.textColor=[UIColor getColor:@"8e8e8e"];
  _descLabel.numberOfLines=0;
  _descLabel.lineBreakMode=NSLineBreakByWordWrapping;
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
