//
//  QQNRFeedTableCell.m
//  Ridding
//
//  Created by zys on 12-9-27.
//
//
#import "QQNRFeedTableCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIColor+XMin.h"
#import "QiNiuUtils.h"
#import "UIButton+WebCache.h"
#import "MapUtil.h"

@implementation QQNRFeedTableCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

  [super setSelected:selected animated:animated];
}


- (void)awakeFromNib {

  [super awakeFromNib];

  
  self.nameLabel.textColor = [UIColor whiteColor];
  self.distanceLabel.textColor = [UIColor whiteColor];
  self.teamCountLabel.textColor = [UIColor whiteColor];

}

- (void)initContentView:(Ridding *)ridding {

  [self.avatorBtn setImage:UIIMAGE_DEFAULT_USER_AVATOR forState:UIControlStateNormal];

  NSURL *url = [QiNiuUtils getUrlBySizeToUrl:self.avatorBtn.frame.size url:ridding.leaderUser.savatorUrl type:QINIUMODE_DESHORT];
  [self.avatorBtn setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];

  self.distanceLabel.text = [ridding.map totalDistanceToKm];
  self.teamCountLabel.text = [NSString stringWithFormat:@"共%d人 ", ridding.userCount];
  self.nameLabel.text = ridding.riddingName;
  
  if([ridding isEnd]){
    
    [self.statusBtn setImage:UIIMAGE_FROMPNG(@"qqnr_main_trip-finish") forState:UIControlStateNormal];
    [self.statusBtn setEnabled:FALSE];
  }else{
    
    [self.statusBtn setImage:UIIMAGE_FROMPNG(@"qqnr_main_trip-ing") forState:UIControlStateNormal];
  }
}

- (void)drawRoutes:(NSArray *)routes riddingId:(long long)riddingId userId:(long long)userId{

  UIImage *image=[self imageFromLocal:riddingId userId:userId];
  [[MapUtil getSinglton] center_map:_mapView routes:routes];
  if(image){
    _mapLineView.image=image;
  }else{
    [[MapUtil getSinglton] update_route_view:_mapView to:_mapLineView line_color:[UIColor getColor:lineColor] routes:routes width:3.0];
    [self saveToLocal:riddingId userId:userId];
  }
  
}

- (void)saveToLocal:(long long)riddingId userId:(long long)userId{

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  //set image
  NSString *savePath= [[paths objectAtIndex:0] stringByAppendingPathComponent:
                       [NSString stringWithFormat:@"s_%lld_%lld.png",riddingId,userId]];
  NSFileManager *manager = [NSFileManager defaultManager];
  if (savePath&&![manager fileExistsAtPath:savePath]) {
    //save pic
    [UIImagePNGRepresentation(_mapLineView.image) writeToFile:savePath atomically:YES];
  }
}

- (UIImage*)imageFromLocal:(long long)riddingId userId:(long long)userId{
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  //set image
  NSString *picPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:
                     [NSString stringWithFormat:@"s_%lld_%lld.png",riddingId,userId]];
  NSFileManager *manager = [NSFileManager defaultManager];
  if (![manager fileExistsAtPath:picPath]) {
    return nil;
  }
  NSData *data=[NSData dataWithContentsOfFile:picPath];
  
  return [UIImage imageWithData:data];
}

- (IBAction)leaderViewTap:(id)selector {

  if (self.delegate) {
    [self.delegate leaderTap:self];
  }
}

- (IBAction)statusTap:(id)selector {

  if (self.delegate) {
    [self.delegate statusTap:self];
  }
}


@end
