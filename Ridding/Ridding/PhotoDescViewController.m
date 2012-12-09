//
//  PhotoDescViewController.m
//  Ridding
//
//  Created by zys on 12-10-30.
//
//

#import "PhotoDescViewController.h"
#import "StaticInfo.h"
#import "ImageUtil.h"
#import "RequestUtil.h"
#import "RiddingPictureDao.h"
@interface PhotoDescViewController ()

@end

@implementation PhotoDescViewController
@synthesize imageView=_imageView;
@synthesize textView=_textView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil info:(NSDictionary*)info{
  RiddingPicture *picture=(RiddingPicture*)[info objectForKey:@"picture"];
  if(picture){
    _image=picture.image;
    _dbId=picture.dbId;
  }
  return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}
- (void)viewDidLoad
{
  self.view.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"feed_cbg")];
  [super viewDidLoad];
  self.barView.leftButton.hidden=YES;
  self.barView.rightButton.hidden=NO;
  [self.barView.rightButton setTitle:@"确定" forState:UIControlStateNormal];
  self.barView.titleLabel.text=@"添加描述";
  self.imageView.image=_image;
  self.imageView.displayAsStack=NO;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat: @"yyyy年MM月dd日HH时mm分"];
  self.timeLabel.text= [formatter stringFromDate:[NSDate date]];
  self.textView.text=[NSString stringWithFormat:@"今天是%@",self.timeLabel.text];
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  self.locationLabel.text=[delegate myLocation].name;
  

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightBtnClicked:(id)sender
{
  [[RiddingPictureDao getSinglton]updateRiddingPictureText:self.textView.text dbId:_dbId];
  [self dismissModalViewControllerAnimated:YES];
}

-(void)leftBtnClicked:(id)sender
{
 
}


-(IBAction)otherClick:(id)sender{
  if(![sender isKindOfClass:[self.textView class]]){
    [self.textView resignFirstResponder];
  }
}


@end
