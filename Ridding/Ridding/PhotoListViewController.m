//
//  PhotoListViewController.m
//  Ridding
//
//  Created by zys on 12-10-8.
//
//

#import "PhotoListViewController.h"
#import "RiddingPictureDao.h"
#import "KTPhotoScrollViewController.h"
#import "StaticInfo.h"
#import "RequestUtil.h"
#import "ImageUtil.h"
#import "ResponseCodeCheck.h"
#import "RNBlurModalView.h"
#import "PhotoUploadBlurView.h"
@interface PhotoListViewController ()

@end

@implementation PhotoListViewController
@synthesize riddingId=_riddingId;
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
  self.barView.titleLabel.text=@"骑行相册";
  queue=[[NSOperationQueue alloc]init];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  //插入数据
  if (myPhotos_ == nil) {
    myPhotos_ = [[Photos alloc] init];
    myPhotos_.riddingId=self.riddingId;
    [myPhotos_ setDelegate:self];
  }
  [self setDataSource:myPhotos_];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  [myPhotos_ flushCache];
  // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark PhotosDelegate
- (void)didFinishSave
{
  [self reloadThumbs];
}


#pragma mark -
#pragma mark photo
- (void)deleteImageAtName:(NSString*)name
{
  dispatch_queue_t q;
  q=dispatch_queue_create("deleteImageAtName", NULL);
  dispatch_async(q, ^{
    NSRange range = [name rangeOfString:@".jpg"];
    long long dbId= [[name substringToIndex:range.location]longLongValue];
    [[RiddingPictureDao getSinglton] deleteRiddingPicture:self.riddingId userId:[StaticInfo getSinglton].user.userId dbId:dbId];
  });
}


- (void)savePhoto:(UIImage *)photo withName:(NSString *)name addToPhotoAlbum:(BOOL)addToPhotoAlbum{
  [myPhotos_ savePhoto:photo withName:name addToPhotoAlbum:addToPhotoAlbum];
}


- (void)didSelectThumbAtIndex:(NSUInteger)index {
  KTPhotoScrollViewController *newController = [[KTPhotoScrollViewController alloc]
                                                initWithDataSource:self.dataSource
                                                andStartWithPhotoAtIndex:index];
  [self.navigationController pushViewController:newController animated:YES];
}

#pragma mark -
#pragma mark navBtn
- (void)leftBtnClicked:(id)sender{
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtnClicked:(id)sender
{
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if(buttonIndex==1){
  }
}


@end
