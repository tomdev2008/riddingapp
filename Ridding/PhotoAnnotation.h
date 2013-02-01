//
//  PhtotAnnotation.h
//  Ridding
//
//  Created by zys on 12-10-13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h> 

@interface PhotoAnnotation : NSObject <MKAnnotation> {
  CLLocationDegrees _latitude;
  CLLocationDegrees _longitude;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic) int index;

- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
