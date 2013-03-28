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
#import "PSLocationManager.h"
@interface ShortMapViewController : BasicViewController<CLLocationManagerDelegate, MKAnnotation, MKMapViewDelegate,PSLocationManagerDelegate>{
  
  NSMutableArray *_routes;
  User *_toUser;
  Ridding *_ridding;
  BOOL _isMyFeedHome;
  
}

@property (nonatomic,retain) IBOutlet UIImageView *route_view;
@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) IBOutlet UILabel *speedLabel;
@property (nonatomic,retain) IBOutlet UILabel *altitudeLabel;


- (id)initWithUser:(User *)toUser ridding:(Ridding *)ridding isMyFeedHome:(BOOL)isMyFeedHome;
@end
