#import "CalloutMapAnnotation.h"

@interface CalloutMapAnnotation ()


@end

@implementation CalloutMapAnnotation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize image = _image;
@synthesize index = _index;

- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude {

  if (self = [super init]) {
    self.latitude = latitude;
    self.longitude = longitude;
  }
  return self;
}

- (CLLocationCoordinate2D)coordinate {

  CLLocationCoordinate2D coordinate;
  coordinate.latitude = self.latitude;
  coordinate.longitude = self.longitude;
  return coordinate;
}

@end
