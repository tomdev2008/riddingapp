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
#import "Utilities.h"
#import "SVProgressHUD.h"
#import "QQNRServerTask.h"
#import "MapCreateDescVCTL.h"
#import "MyLocationManager.h"
#import "FirstAnnotationView.h"
#import "BlockAlertView.h"
#import "UIImage+UIImage_Retina4.h"
#import "ShowTapAnnotation.h"
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

  self.canMoveLeft=NO;
  _longPressCount=0;
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  if ([prefs boolForKey:[[StaticInfo getSinglton] kMapCreateTipsKey]]) {
    [self.deleteBtn removeFromSuperview];
    [self.tipLabel removeFromSuperview];
    [self.tipBgView removeFromSuperview];
  }
  UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewClick:)]; //动态添加点击操作
  [self.mapView addGestureRecognizer:viewTap];
  UILongPressGestureRecognizer *dropPin = [[UILongPressGestureRecognizer alloc] init];
  [dropPin addTarget:self action:@selector(handleLongPress:)];
  dropPin.minimumPressDuration = 0.3;
  [self.mapView addGestureRecognizer:dropPin];
  
  self.searchField.returnKeyType = UIReturnKeyGo;

  _locationViews = [[NSMutableArray alloc] init];
  _ridding = [[Ridding alloc] init];

  self.hasLeftView = true;
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list_hl") forState:UIControlStateHighlighted];
  
 
  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create_disable") forState:UIControlStateNormal];
  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create_disable") forState:UIControlStateHighlighted];
  [self.barView.rightButton setEnabled:NO];
  [self.barView.rightButton setHidden:NO];
  self.barView.titleLabel.text = @"画路线";
  
  self.positionsView.image=[UIIMAGE_FROMPNG(@"qqnr_pd_comment_tabbar_bg") stretchableImageWithLeftCapWidth:1 topCapHeight:0];

  _isUpdate=FALSE;

 
  if(![prefs boolForKey:kStaticInfo_First_mapCreate]){
    UIButton *imageView=[UIButton buttonWithType:UIButtonTypeCustom];
    imageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [imageView setImage:[UIImage retina4ImageNamed:@"qqnr_mapcreate_help" type:@"png"] forState:UIControlStateNormal];
    [imageView addTarget:self action:@selector(imageViewCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageView];
  }
  [super viewDidLoad];

}

- (void)imageViewCilck:(id)sender{
  UIView *view=(UIView*)sender;
  [view removeFromSuperview];
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs setBool:YES forKey:kStaticInfo_First_mapCreate];
}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  if (!self.didAppearOnce) {
    self.didAppearOnce = YES;
    [self checkLocation];
    [self checkCreateBtn];
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

- (void)leftBtnClicked:(id)sender{
  
  [self.searchField resignFirstResponder];
  
  [super leftBtnClicked:sender];
}

- (void)rightBtnClicked:(id)sender {

  self.barView.rightButton.enabled = NO;
  if (!_succCreate) {
    [SVProgressHUD showSuccessWithStatus:@"生成路线后才能创建活动~" duration:2.0];
    self.barView.rightButton.enabled = YES;
    return;
  }
  MapCreateDescVCTL *descVCTL = [[MapCreateDescVCTL alloc] initWithNibName:@"MapCreateDescVCTL" bundle:nil ridding:_ridding isShortPath:NO];
  [self.navigationController pushViewController:descVCTL animated:YES];
  self.barView.rightButton.enabled = YES;
  self.didAppearOnce=NO;
}


- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {

  if (gestureRecognizer.state != UIGestureRecognizerStateBegan){
    return;
  }
  if ([gestureRecognizer isMemberOfClass:[UILongPressGestureRecognizer class]] && (gestureRecognizer.state == UIGestureRecognizerStateEnded)) {
    [self.mapView removeGestureRecognizer:gestureRecognizer];
  }
  NSArray *annotations = [self.mapView annotations];
  if (annotations && [annotations count] > 0) {
    for (id <MKAnnotation> annotation in annotations) {
      [self.mapView deselectAnnotation:annotation animated:NO];
      if([annotation isKindOfClass:[FirstAnnotation class]]||[annotation isKindOfClass:[ShowTapAnnotation class]]){
        [self.mapView removeAnnotation:annotation];
      }
    }
  }
  _longPressCount++;
  [SVProgressHUD showWithStatus:@"请稍后"];
  CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
  CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
  FirstAnnotation *annotation = [[FirstAnnotation alloc] initWithLocation:touchMapCoordinate];
  CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
  CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
  [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
    if([placemarks count]==0){
      [SVProgressHUD showErrorWithStatus:@"无法找到当前位置" duration:1.0];
    }else{
      for (CLPlacemark *mark in placemarks) {
        annotation.title = mark.name;
        if (mark.locality) {
          annotation.city = mark.locality;
        } else if (annotation.title) {
          annotation.city = annotation.title;
        } else {
          annotation.city = @"";
        }
        [self addNewAnnotation:annotation];
        break;
      }
      [SVProgressHUD dismiss];
      [self checkShowIOS5Tips];
    }
  }];
}


- (void)checkShowIOS5Tips{
  if([Utilities deviceVersion]<6.0){
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs boolForKey:kStaticInfo_Ios5Tips]||(_longPressCount>5&&[_locationViews count]==0)) {
      
      BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"小提示" message:@"您的手机版本低于ios6,选择起点、终点是需要长按才能添加。"];
      [alert setCancelButtonWithTitle:@"我知道了" block:^(void) {
        
      }];
      [alert show];
      [prefs setBool:YES forKey:kStaticInfo_Ios5Tips];
      _longPressCount=0;
    }
  }
}

#pragma mark mapView delegate functions
//选中某个annotation时
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
  //添加点击弹出图
  if ([view.annotation isKindOfClass:[FirstAnnotation class]]) {
    
    FirstAnnotation *firstAnnotation = (FirstAnnotation *) view.annotation;
    CLLocationCoordinate2D location = firstAnnotation.coordinate;
    ShowTapAnnotation *tapAnnotation = [[ShowTapAnnotation alloc] initWithLatitude:location.latitude andLongitude:location.longitude];
    [self.mapView addAnnotation:tapAnnotation];
    [self.mapView selectAnnotation:tapAnnotation animated:YES];
    
  }
}
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {

  self.route_view.hidden = YES;
}

//地图移动结束后的操作
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

  [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:line_color routes:_routes width:5.0];
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
  
  if([annotation isKindOfClass:[ShowTapAnnotation class]]){
    FirstAnnotationView *annotationView = (FirstAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"FirstAnnotationView"];
    if (!annotationView) {
      annotationView = [[FirstAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"FirstAnnotationView"];
    }
    MapCreateAnnotationView  *view = [[[NSBundle mainBundle] loadNibNamed:@"MapCreateAnnotationView" owner:self options:nil] objectAtIndex:0];
    view.delegate=self;
    [annotationView.contentView addSubview:view];
    return annotationView;
  }
  
   if ([annotation isKindOfClass:[FirstAnnotation class]]) {
     MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"PhotoAnnotationIdentifier"];
     if(!pinView){
       pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                              reuseIdentifier:@"PhotoAnnotationIdentifier"];
       [pinView setCanShowCallout:NO];
       [pinView setDraggable:NO];
     }else{
       pinView.annotation=annotation;
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
      if([annotation isKindOfClass:[FirstAnnotation class]]||[annotation isKindOfClass:[ShowTapAnnotation class]]){
        [self.mapView removeAnnotation:annotation];
      }
    }
  }
  
}


- (void)addNewAnnotation:(FirstAnnotation*)annotation{
  
  MKCoordinateRegion region;
  region.center = annotation.coordinate;
  region.span = self.mapView.region.span;
  [self.mapView setRegion:region animated:YES];
  [self.mapView addAnnotation:annotation];
  if([Utilities deviceVersion]>=6.0){
    [self.mapView selectAnnotation:annotation animated:YES];
  }else{
    dispatch_async(dispatch_queue_create("drawRoutes", NULL), ^{
      [NSThread sleepForTimeInterval:0.5];
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView selectAnnotation:annotation animated:YES];
        
      });
    });
  }

  _nowAnnotation=annotation;
  [SVProgressHUD dismiss];
}


- (void)addMyAnnotation:(MyAnnotationType)type {
  
  [self removeAllFirstAnnotationView];
  if(!_nowAnnotation){
    return;
  }
  if(_isUpdate){
    [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create_disable") forState:UIControlStateNormal];
    [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create_disable") forState:UIControlStateHighlighted];
    [self.barView.rightButton setEnabled:NO];
    _isUpdate=FALSE;
  }
  MyAnnotation *myAnnotation=[[MyAnnotation alloc]initWithLocation:_nowAnnotation.coordinate];
  myAnnotation.type=type;
  myAnnotation.title=_nowAnnotation.title;
  [self.mapView addAnnotation:myAnnotation];
  [self.mapView selectAnnotation:myAnnotation animated:YES];
  
  LocationView *locationView = [[LocationView alloc] initWithFrame:CGRectMake([_locationViews count] * viewWidth, 0, viewWidth, viewHeight)];
  locationView.latitude = (CGFloat) _nowAnnotation.coordinate.latitude;
  locationView.longtitude = (CGFloat) _nowAnnotation.coordinate.longitude;
  locationView.totalLocation = _nowAnnotation.title;
  locationView.annotation = myAnnotation;
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

  NSArray *annotations = [self.mapView annotations];
  if (annotations && [annotations count] > 0) {
    for (id <MKAnnotation> annotation in annotations) {
      [self.mapView deselectAnnotation:annotation animated:NO];
      if([annotation isKindOfClass:[FirstAnnotation class]]||[annotation isKindOfClass:[ShowTapAnnotation class]]){
        [self.mapView removeAnnotation:annotation];
      }
    }
  }
  LocationView *locationView = (LocationView *) gesture.view;
  [self.mapView selectAnnotation:locationView.annotation animated:YES];
}


#pragma mark -
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

  if (![textField.text isEqualToString:@""]) {
    [SVProgressHUD show];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:textField.text completionHandler:^(NSArray *placemarks, NSError *error) {
      if([placemarks count]==0){
        [SVProgressHUD showErrorWithStatus:@"找不到地址!" duration:1.0];
      }else{
        
        MapSearchVCTL *searchVCTL = [[MapSearchVCTL alloc] initWithNibName:@"MapSearchVCTL" bundle:nil placemarks:placemarks];
        searchVCTL.delegate = self;
        [self.navigationController pushViewController:searchVCTL animated:YES];
        [SVProgressHUD dismiss];

      }
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
 
  self.createBtn.enabled = YES;
  _hasBeginPoint=FALSE;
  _hasEndPoint=FALSE;
  [self checkCreateBtn];
  NSArray *annotations = [self.mapView annotations];
  if (annotations && [annotations count] > 0) {
    for (id <MKAnnotation> annotation in annotations) {
      [self.mapView deselectAnnotation:annotation animated:NO];
      if([annotation isKindOfClass:[FirstAnnotation class]]||[annotation isKindOfClass:[ShowTapAnnotation class]]){
        [self.mapView removeAnnotation:annotation];
      }
    }
  }
}

- (IBAction)myLocationBtn:(id)sender {

  self.myLocationBtn.enabled = NO;
  [self removeAllFirstAnnotationView];
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
    FirstAnnotation *annotation = [[FirstAnnotation alloc] initWithLocation:location.location.coordinate];
    annotation.title = location.name;
    if (location.city) {
      annotation.city = location.city;
    } else if (annotation.title) {
      annotation.city = annotation.title;
    } else {
      annotation.city = @"";
    }
    [self addNewAnnotation:annotation];
    [SVProgressHUD dismiss];
  }];
   self.myLocationBtn.enabled = YES;
}

- (IBAction)deleteTipsClick:(id)sender{
  
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  
  [prefs setBool:TRUE forKey:[[StaticInfo getSinglton] kMapCreateTipsKey]];
  [self.tipBgView removeFromSuperview];
  [self.tipLabel removeFromSuperview];
  [self.deleteBtn removeFromSuperview];
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
  _ridding.riddingType=RiddingType_FarAway;
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
          [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:line_color routes:_routes width:5.0];
          if ([_routes count] > 0) {
            [[MapUtil getSinglton] center_map:self.mapView routes:_routes];
            _succCreate = TRUE;
            UIGraphicsBeginImageContext(self.coverImageView.frame.size); //currentView 当前的view
            [self.coverImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
            _newCoverImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [SVProgressHUD dismiss];
            _isUpdate=TRUE;
            [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create") forState:UIControlStateNormal];
            [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create") forState:UIControlStateHighlighted];
            [self.barView.rightButton setEnabled:YES];
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
  [self.barView.rightButton setEnabled:NO];
  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create_disable") forState:UIControlStateNormal];
  [self checkCreateBtn];
}

- (void)didSelectPlaceMarks:(MapSearchVCTL *)mapSearchVCTL placemark:(CLPlacemark *)placemark {

  FirstAnnotation *annotation = [[FirstAnnotation alloc] initWithLocation:placemark.location.coordinate];
  annotation.title = placemark.name;
  annotation.city = placemark.locality;
  [self addNewAnnotation:annotation];
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

#pragma MapCreateAnnotationView Delegate
- (void)beginBtnClick:(MapCreateAnnotationView*)view{
  
  _longPressCount=0;
  [self addMyAnnotation:MyAnnotationType_BEGIN];
}

- (void)passBtnClick:(MapCreateAnnotationView*)view{
  
  _longPressCount=0;
  [self addMyAnnotation:MyAnnotationType_MID];
}

- (void)endBtnClick:(MapCreateAnnotationView*)view{
  
  _longPressCount=0;
  [self addMyAnnotation:MyAnnotationType_END];
}

- (void)removeAllFirstAnnotationView{
  NSArray *annotations = [self.mapView annotations];
  if (annotations && [annotations count] > 0) {
    for (id <MKAnnotation> annotation in annotations) {
      if ([annotation isKindOfClass:[FirstAnnotation class]]||[annotation isKindOfClass:[ShowTapAnnotation class]]) {
        [self.mapView removeAnnotation:annotation];
      }
    }
  }
}




@end
