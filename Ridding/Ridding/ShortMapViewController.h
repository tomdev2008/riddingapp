//
//  ShotMapViewController.h
//  Ridding
//
//  Created by zys on 13-3-13.
//
//

#import "BasicViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ShortMapViewController : BasicViewController<CLLocationManagerDelegate, MKAnnotation, MKMapViewDelegate>{
  
  NSMutableArray *_routes;
  User *_toUser;
  Ridding *_ridding;
  BOOL _isMyFeedHome;
  
}

@property (nonatomic,retain) IBOutlet UIImageView *route_view;
@property (nonatomic,retain) IBOutlet MKMapView *mapView;


- (id)initWithUser:(User *)toUser ridding:(Ridding *)ridding isMyFeedHome:(BOOL)isMyFeedHome;
@end
