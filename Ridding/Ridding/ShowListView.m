//
//  ShowListView.m
//  Ridding
//
//  Created by zys on 13-3-17.
//
//

#import "ShowListView.h"

@implementation ShowListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
    }
    return self;
}

- (void)awakeFromNib{
  [super awakeFromNib];
  self.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_map_more_listbg")];
}

- (IBAction)picSelected:(id)sender{
  
  [self reset];
  self.picBgView.hidden=NO;
  self.picImageView.image=UIIMAGE_FROMPNG(@"qqnr_map_more_icon_photo_hl");
  
  if(self.delegate){
    [self.delegate picClick:self];
  }
  
}

- (IBAction)weatherSelected:(id)sender{
  
  [self reset];
  self.weatherBgView.hidden=NO;
  self.weatherImageView.image=UIIMAGE_FROMPNG(@"qqnr_map_more_icon_weather_hl");
  if(self.delegate){
    [self.delegate weatherClick:self];
  }
}

- (IBAction)settingClick:(id)sender{
  if(self.delegate){
    [self.delegate settingClick:self];
  }
}

- (void)reset{
  
  self.picBgView.hidden=YES;
  self.picImageView.image=UIIMAGE_FROMPNG(@"qqnr_map_more_icon_photo");
  self.weatherBgView.hidden=YES;
  self.weatherImageView.image=UIIMAGE_FROMPNG(@"qqnr_map_more_icon_weather");
  
}


@end
