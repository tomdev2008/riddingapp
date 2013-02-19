


#import "AnnotationPhotoView.h"
#import "UIButton+WebCache.h"
#import "QiNiuUtils.h"
@implementation AnnotationPhotoView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)initViewWithPhoto:(RiddingPicture*)riddingPicture{
  
  NSURL *url=[QiNiuUtils getUrlBySizeToUrl:self.photoView.frame.size url:riddingPicture.photoUrl type:QINIUMODE_DEDEFAULT];
  [self.photoView setImageWithURL:url placeholderImage:nil];
  
  url=[QiNiuUtils getUrlBySizeToUrl:self.avatorView.frame.size url:riddingPicture.user.savatorUrl type:QINIUMODE_DEDEFAULT];
  [self.avatorView setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
  
  self.nameLabel.text=riddingPicture.user.name;
  self.locationLabel.text=riddingPicture.location;
}

- (IBAction)photoClick:(id)sender{
  
  if(self.delegate){
    [self.delegate photoClick:self];
  }
}
@end
