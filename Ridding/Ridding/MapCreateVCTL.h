//
//  MapCreateVCTL.h
//  Ridding
//
//  Created by zys on 12-11-15.
//
//

#import "BasicViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "MyAnnotation.h"
#import "CreateAnnotationView.h"
#import "Map.h"
#import "MapSearchVCTL.h"
#import "FirstAnnotation.h"
#import "MapCreateAnnotationView.h"
@interface MapCreateVCTL : BasicViewController <MKAnnotation, MKMapViewDelegate, UISearchBarDelegate, UITextFieldDelegate, UIScrollViewDelegate, CreateAnnotationViewDelegate, MapSearchVCTLDelegate,MapCreateAnnotationViewDelegate> {
  BOOL _isSearching;
  NSMutableArray *_locationViews;
  FirstAnnotation *_nowAnnotation;
  NSMutableArray *_routes;
  UIColor *line_color;
  BOOL _succCreate;
  Ridding *_ridding;
  UIImage *_newCoverImage;
  BOOL _hasBeginPoint;
  BOOL _hasEndPoint;
  BOOL _isUpdate;
  int _longPressCount;
}
@property (nonatomic, retain) IBOutlet UIImageView *route_view;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIView *coverImageView;
@property (nonatomic, retain) IBOutlet UITextField *searchField;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *createBtn;
@property (nonatomic, retain) IBOutlet UIButton *clearBtn;
@property (nonatomic, retain) IBOutlet UIButton *myLocationBtn;
@property (nonatomic, retain) IBOutlet UIImageView *searchFieldView;
@property (nonatomic, retain) IBOutlet UIImageView *positionsView;
@property (nonatomic, retain) IBOutlet UIImageView *tipBgView;
@property (nonatomic, retain) IBOutlet UILabel *tipLabel;
@property (nonatomic, retain) IBOutlet UIButton *deleteBtn;


@end
