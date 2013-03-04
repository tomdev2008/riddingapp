//
//  ShowTapAnnotation.h
//  Ridding
//
//  Created by zys on 13-2-21.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface ShowTapAnnotation : NSObject <MKAnnotation> {
  CLLocationDegrees _latitude;
  CLLocationDegrees _longitude;
}


- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
