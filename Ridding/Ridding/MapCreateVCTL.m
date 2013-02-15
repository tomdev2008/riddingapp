//
//  MapCreateVCTL.m
//  Ridding
//
//  Created by zys on 12-11-15.
//
//

#import "MapCreateVCTL.h"
#import "LocationView.h"
#import "MapUtil.h"
#import "UIColor+XMin.h"

#import "SVProgressHUD.h"
#import "QQNRServerTask.h"
#import "MapCreateDescVCTL.h"
#import "MyLocationManager.h"

@interface MapCreateVCTL ()

@end

@implementation MapCreateVCTL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];

  UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewClick:)]; //动态添加点击操作
  [self.mapView addGestureRecognizer:viewTap];
  UILongPressGestureRecognizer *dropPin = [[UILongPressGestureRecognizer alloc] init];
  [dropPin addTarget:self action:@selector(handleLongPress:)];
  dropPin.minimumPressDuration = 0.3;
  [self.mapView addGestureRecognizer:dropPin];

  self.searchField.returnKeyType = UIReturnKeyGo;

  _locationViews = [[NSMutableArray alloc] init];
  _ridding = [[Ridding alloc] init];

  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list") forState:UIControlStateHighlighted];
  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create") forState:UIControlStateNormal];
  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create") forState:UIControlStateHighlighted];
  [self.barView.rightButton setHidden:YES];
  self.barView.titleLabel.text = @"画路线";
  
  self.positionsView.image=[UIIMAGE_FROMPNG(@"qqnr_dl_search_bg") stretchableImageWithLeftCapWidth:1 topCapHeight:0];
  self.searchFieldView.image=[UIIMAGE_FROMPNG(@"qqnr_dl_search_bg") stretchableImageWithLeftCapWidth:1 topCapHeight:0];
  
  self.hasLeftView = TRUE;
}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  if (!self.didAppearOnce) {
    self.didAppearOnce = YES;
    [self checkLocation];
  }
}

- (void)checkLocation {

  if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    [SVProgressHUD showSuccessWithStatus:@"请开启定位服务以定位到您的位置" duration:2.0];
  } else {
    MyLocationManager *manager = [MyLocationManager getSingleton];
    [manager startUpdateMyLocation:^(QQNRMyLocation *location) {
      if (location == nil) {
        [SVProgressHUD showSuccessWithStatus:@"请开启定位服务以定位到您的位置" duration:2.0];
        return;
      }
      MKCoordinateRegion region;
      region.center = location.location.coordinate;
      region.span = MKCoordinateSpanMake(0.1, 0.1);
      [self.mapView setRegion:region animated:YES];
    }];

  }
}

- (void)rightBtnClicked:(id)sender {

  self.barView.rightButton.enabled = NO;
  if (!_succCreate) {
    [SVProgressHUD showSuccessWithStatus:@"生成路线后才能创建活动~" duration:2.0];
    self.barView.rightButton.enabled = YES;
    return;
  }
  MapCreateDescVCTL *descVCTL = [[MapCreateDescVCTL alloc] initWithNibName:@"MapCreateDescVCTL" bundle:nil ridding:_ridding];
  [self.navigationController pushViewController:descVCTL animated:YES];
  self.barView.rightButton.enabled = YES;
}


- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {

  if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
    return;
  if ([gestureRecognizer isMemberOfClass:[UILongPressGestureRecognizer class]] && (gestureRecognizer.state == UIGestureRecognizerStateEnded)) {
    [self.mapView removeGestureRecognizer:gestureRecognizer];
  }
  [SVProgressHUD showWithStatus:@"加载中"];
  CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
  CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
  MyAnnotation *annotation = [[MyAnnotation alloc] initWithLocation:touchMapCoordinate];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
  CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
  [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
    for (CLPlacemark *mark in placemarks) {
      annotation.title = mark.name;
      if (mark.locality) {
        annotation.city = mark.locality;
      } else if (annotation.title) {
        annotation.city = annotation.title;
      } else {
        annotation.city = @"";
      }
      _nowAnnotation=annotation;
      [self showTapView];
      break;
    }
    [SVProgressHUD dismiss];
  }];
}

#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {

  self.route_view.hidden = YES;
}

//地图移动结束后的操作
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

  [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:line_color routes:_routes];
  self.route_view.hidden = NO;
  [self.route_view setNeedsDisplay];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
  // If it's the user location, just return nil.
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  
  // Handle any custom annotations.
  if ([annotation isKindOfClass:[MyAnnotation class]]) {
    CreateAnnotationView *pinView = [[CreateAnnotationView alloc] initWithAnnotation:annotation
                                                                     reuseIdentifier:@"CreateAnnotationView"];
    [pinView setCanShowCallout:YES];
    [pinView setDraggable:NO];
    pinView.delegate = self;
    pinView.annotation = annotation;
    MyAnnotation *myAnnotation=(MyAnnotation*)annotation;
    switch (myAnnotation.type) {
      case MyAnnotationType_BEGIN:
        pinView.image=UIIMAGE_FROMPNG(@"qqnr_dl_map_icon_start");
        break;
      case MyAnnotationType_MID:
        pinView.image=UIIMAGE_FROMPNG(@"qqnr_dl_map_icon_pass");
        break;
      case MyAnnotationType_END:
        pinView.image=UIIMAGE_FROMPNG(@"qqnr_dl_map_icon_end");
        break;
        
      default:
        break;
    }
    return pinView;
  }

  return nil;
}

- (void)mapViewClick:(UITapGestureRecognizer *)gestureRecognize {

  UIView *view = gestureRecognize.view;
  if (![view isKindOfClass:[UITextField class]]) {
    [_searchField resignFirstResponder];
  }
  NSArray *annotations = [self.mapView annotations];
  if (annotations && [annotations count] > 0) {
    for (id <MKAnnotation> annotation in annotations) {
      [self.mapView deselectAnnotation:annotation animated:NO];

    }
  }
     
}


- (void)addNewAnnotation{

  _succCreate = FALSE;
  [self hideAndDeleteAnnotation];
  MKCoordinateRegion region;
  region.center = _nowAnnotation.coordinate;
  region.span = self.mapView.region.span;
  [self.mapView setRegion:region animated:YES];
  [self.mapView addAnnotation:_nowAnnotation];
  [self.mapView selectAnnotation:_nowAnnotation animated:YES];
  [SVProgressHUD dismiss];
}


- (void)addTapView:(MyAnnotationType)type {
  
  _nowAnnotation.checked = TRUE;
  _nowAnnotation.type=type;
  [self addNewAnnotation];
  LocationView *locationView = [[LocationView alloc] initWithFrame:CGRectMake([_locationViews count] * viewWidth, 0, viewWidth, viewHeight)];
  locationView.latitude = _nowAnnotation.coordinate.latitude;
  locationView.longtitude = _nowAnnotation.coordinate.longitude;
  locationView.totalLocation = _nowAnnotation.title;
  locationView.annotation = _nowAnnotation;
  locationView.userInteractionEnabled = YES;
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationViewTap:)];
  [locationView addGestureRecognizer:tapGesture];
  [locationView setSubViews];
  switch (type) {
    case MyAnnotationType_BEGIN: {
      if ([_locationViews count] > 0) {
        LocationView *view = [_locationViews objectAtIndex:0];
        if (view.annotation && view.annotation.type == MyAnnotationType_BEGIN) {
          [self.mapView removeAnnotation:view.annotation];
          [_locationViews removeObject:view];
        }
      }
      [_locationViews insertObject:locationView atIndex:0];
      [self reloadScrollView];
      _hasBeginPoint=TRUE;
    }
      break;
    case MyAnnotationType_MID: {
      LocationView *view = [_locationViews lastObject];
      if (view.annotation && view.annotation.type == MyAnnotationType_END) {
        [_locationViews insertObject:locationView atIndex:([_locationViews count] - 1)];
        [self reloadScrollView];
      } else {
        [_locationViews addObject:locationView];
        [self.scrollView addSubview:locationView];
      }
    }
      break;
    case MyAnnotationType_END: {
      LocationView *view = [_locationViews lastObject];
      if (view.annotation && view.annotation.type == MyAnnotationType_END) {
        [self.mapView removeAnnotation:view.annotation];
        [_locationViews removeLastObject];
        [_locationViews addObject:locationView];
        [self reloadScrollView];
        break;
      }
      [_locationViews addObject:locationView];
      [self.scrollView addSubview:locationView];
      _hasEndPoint=TRUE;
    }
      break;
    default:
      break;
  }
  self.scrollView.contentSize = CGSizeMake(viewWidth* [_locationViews count], viewHeight);
  [self hideTapView];
  [self checkCreateBtn];
  
}



- (void)reloadScrollView {

  for (LocationView *view in self.scrollView.subviews) {
    [view removeFromSuperview];
  }
  int index = 0;
  for (LocationView *locationView in _locationViews) {
    locationView.frame = CGRectMake(index * viewWidth, 0, viewWidth, viewHeight);
    [self.scrollView addSubview:locationView];
    self.scrollView.contentSize = CGSizeMake(viewWidth* [_locationViews count], viewHeight);
    index++;
  }
}

- (void)locationViewTap:(UIGestureRecognizer *)gesture {

  LocationView *locationView = (LocationView *) gesture.view;
  [self.mapView selectAnnotation:locationView.annotation animated:YES];
}

- (void)hideAndDeleteAnnotation {

  if (_nowAnnotation && !_nowAnnotation.checked) {
    [self.mapView removeAnnotation:_nowAnnotation];
    [self hideTapView];
  }
}


#pragma mark -
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

  if (![textField.text isEqualToString:@""]) {
    [SVProgressHUD show];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:textField.text completionHandler:^(NSArray *placemarks, NSError *error) {
      MapSearchVCTL *searchVCTL = [[MapSearchVCTL alloc] initWithNibName:@"MapSearchVCTL" bundle:nil placemarks:placemarks];
      searchVCTL.delegate = self;
      [self.navigationController pushViewController:searchVCTL animated:YES];
      [SVProgressHUD dismiss];
    }];
  }
  [textField resignFirstResponder];
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

  _isSearching = TRUE;
  [textField setText:@""];
  return YES;
}


#pragma mark IBAction
- (IBAction)beginClick:(id)sender {

  self.beginBtn.enabled = NO;
  [self addTapView:MyAnnotationType_BEGIN];
}

- (IBAction)midClick:(id)sender {

  self.midBtn.enabled = NO;
  [self addTapView:MyAnnotationType_MID];
}

- (IBAction)endClick:(id)sender {

  self.endBtn.enabled = NO;
  [self addTapView:MyAnnotationType_END];
}

- (IBAction)clearClick:(id)sender {

  self.createBtn.enabled = NO;
  for (LocationView *locationView in _locationViews) {
    [self.mapView removeAnnotation:locationView.annotation];
    [locationView removeFromSuperview];
  }
  if (_nowAnnotation) {
    [self.mapView removeAnnotation:_nowAnnotation];
  }
  [_locationViews removeAllObjects];
  [_routes removeAllObjects];
  _nowAnnotation = nil;
  self.route_view.image = nil;
  [self hideTapView];
  self.createBtn.enabled = YES;
  _hasBeginPoint=FALSE;
  _hasEndPoint=FALSE;
  [self checkCreateBtn];
}

- (IBAction)myLocationBtn:(id)sender {

  self.myLocationBtn.enabled = NO;
  if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    [SVProgressHUD showErrorWithStatus:@"请开启定位服务以定位到您的位置" duration:2.0];
    self.myLocationBtn.enabled = YES;
    return;
  }
  MKCoordinateRegion region;
  region.center = [self.mapView userLocation].coordinate;
  region.span = self.mapView.region.span;
  [self.mapView setRegion:region animated:YES];

  MyLocationManager *manager = [MyLocationManager getSingleton];
  [manager startUpdateMyLocation:^(QQNRMyLocation *location) {
    if (location == nil) {
      [SVProgressHUD showSuccessWithStatus:@"请开启定位服务以定位到您的位置" duration:2.0];
      self.myLocationBtn.enabled = YES;
      return;
    }
    MyAnnotation *annotation = [[MyAnnotation alloc] initWithLocation:location.location.coordinate];
    annotation.title = location.name;
    if (location.city) {
      annotation.city = location.city;
    } else if (annotation.title) {
      annotation.city = annotation.title;
    } else {
      annotation.city = @"";
    }
    _nowAnnotation=annotation;
    [self showTapView];
    [SVProgressHUD dismiss];
  }];
   self.myLocationBtn.enabled = YES;
}

- (IBAction)createClick:(id)sender {

  [MobClick event:@"2012111902"];
  [self.mapView deselectAnnotation:_nowAnnotation animated:YES];
  _succCreate = FALSE;
  self.createBtn.enabled = NO;
  if (!_hasEndPoint||!_hasBeginPoint) {
    [SVProgressHUD showErrorWithStatus:@"必须要有起点终点噢!^_^" duration:2];
    self.createBtn.enabled = YES;
    return;
  }
  NSMutableArray *locationArray = [[NSMutableArray alloc] initWithCapacity:[_locationViews count]];
  NSMutableArray *nameArray = [[NSMutableArray alloc] init];
  int index = 0;
  if ([_locationViews count] > 0) {
    for (LocationView *view in _locationViews) {
      if (index != 0 && index != [_locationViews count] - 1) {
        [nameArray addObject:view.totalLocation];
      }
      [locationArray addObject:[NSString stringWithFormat:@"%f,%f", view.latitude, view.longtitude]];
    }
  }
  _ridding.map.midLocations = nameArray;
  _ridding.map.beginLocation = ((LocationView *) [_locationViews objectAtIndex:0]).totalLocation;
  _ridding.map.endLocation = ((LocationView *) [_locationViews lastObject]).totalLocation;
  _ridding.map.mapTaps = locationArray;
  _ridding.map.cityName = ((LocationView *) [_locationViews objectAtIndex:0]).annotation.city;
  self.route_view.image = nil;
  [_routes removeAllObjects];
  [SVProgressHUD showWithStatus:@"路线生成中"];
  dispatch_async(dispatch_queue_create("drawRoutes", NULL), ^{
    line_color = [UIColor getColor:lineColor];
    [[MapUtil getSinglton] calculate_routes_from:locationArray map:_ridding.map];
    if (_ridding.map) {
      _routes = [[MapUtil getSinglton] decodePolyLineArray:_ridding.map.mapPoint];
      dispatch_async(dispatch_get_main_queue(), ^{
        if (self) {
          [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:line_color routes:_routes];
          if ([_routes count] > 0) {
            [[MapUtil getSinglton] center_map:self.mapView routes:_routes];
            _succCreate = TRUE;
            UIGraphicsBeginImageContext(self.coverImageView.frame.size); //currentView 当前的view
            [self.coverImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
            _newCoverImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [SVProgressHUD dismiss];
            [self.barView.rightButton setHidden:NO];
          } else {
            [SVProgressHUD showErrorWithStatus:@"生成失败,google的网络不太好,再来一次吧^_^!!" duration:2];
            [MobClick event:@"2012111907"];
          }
        }
        
      });
    }
    self.createBtn.enabled = YES;
  });
}
#pragma mark TapView
- (void)showTapView {

  if (!self.tapView.hidden) {
    return;
  }
  self.tapView.hidden = NO;
  self.beginBtn.enabled = YES;
  self.midBtn.enabled = YES;
  self.endBtn.enabled = YES;
}

- (void)hideTapView {

  if (self.tapView.hidden) {
    return;
  }
  self.tapView.hidden = YES;
  self.beginBtn.enabled = NO;
  self.midBtn.enabled = NO;
  self.endBtn.enabled = NO;

}
#pragma mark CreateAnnotationView delegate
- (void)imageViewDelete:(CreateAnnotationView *)view {

  _succCreate = FALSE;
  MyAnnotation *annotation = view.annotation;
  [self.mapView removeAnnotation:annotation];
  BOOL findView = FALSE;
  for (LocationView *locationView in _scrollView.subviews) {
    if (locationView.annotation == annotation) {
      if(locationView.annotation.type==MyAnnotationType_BEGIN){
        _hasBeginPoint=FALSE;
      }else if(locationView.annotation.type==MyAnnotationType_END){
        _hasEndPoint=FALSE;
      }
      [locationView removeFromSuperview];
      [_locationViews removeObject:locationView];
      findView = TRUE;
    }
    if (findView) {
      CGRect frame = locationView.frame;
      frame.origin.x = frame.origin.x - frame.size.width;
      locationView.frame = frame;
    }
  }
  [self checkCreateBtn];
}

- (void)didSelectPlaceMarks:(MapSearchVCTL *)mapSearchVCTL placemark:(CLPlacemark *)placemark {

  MyAnnotation *annotation = [[MyAnnotation alloc] initWithLocation:placemark.location.coordinate];
  annotation.title = placemark.name;
  annotation.city = placemark.locality;
  _nowAnnotation=annotation;
  [self showTapView];
}


- (void)checkCreateBtn{
  if(_hasBeginPoint&&_hasEndPoint){
    self.createBtn.enabled=TRUE;
    [self.createBtn setImage:UIIMAGE_FROMPNG(@"qqnr_dl_tabbar_icon_confirm") forState:UIControlStateNormal];
    [self.createBtn setImage:UIIMAGE_FROMPNG(@"qqnr_dl_tabbar_icon_confirm_press") forState:UIControlStateHighlighted];
  }else{
    self.createBtn.enabled=FALSE;
    [self.createBtn setImage:UIIMAGE_FROMPNG(@"qqnr_dl_tabbar_icon_confirm_disable") forState:UIControlStateNormal];
    [self.createBtn setImage:UIIMAGE_FROMPNG(@"qqnr_dl_tabbar_icon_confirm_disable") forState:UIControlStateHighlighted];
  }
}


@end
