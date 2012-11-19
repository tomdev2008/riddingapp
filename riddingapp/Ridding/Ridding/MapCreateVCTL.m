//
//  MapCreateVCTL.m
//  Ridding
//
//  Created by zys on 12-11-15.
//
//

#import "MapCreateVCTL.h"
#import "RequestUtil.h"
#import "LocationView.h"
#import <QuartzCore/QuartzCore.h>
#import "MapUtil.h"
#import "UIColor+XMin.h"
#import "UIImage+Utilities.h"
#import "ImageUtil.h"
@interface MapCreateVCTL ()

@end

@implementation MapCreateVCTL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _myLocation = [[CLLocationManager alloc] init];
    [_myLocation setDelegate:self];
    [_myLocation setDesiredAccuracy:kCLLocationAccuracyBest];
    [_myLocation startUpdatingLocation];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initHUD];
  [self.mapView setShowsUserLocation:YES];
  UITapGestureRecognizer *viewTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapViewClick:)]; //动态添加点击操作
  [self.mapView addGestureRecognizer:viewTap];
  UILongPressGestureRecognizer *dropPin = [[UILongPressGestureRecognizer alloc] init];
  [dropPin addTarget:self action:@selector(handleLongPress:)];
	dropPin.minimumPressDuration = 0.3;
	[self.mapView addGestureRecognizer:dropPin];
  MKCoordinateRegion region;
  region.center=_myLocation.location.coordinate;
  region.span=MKCoordinateSpanMake(0.1,0.1);
  
  self.searchField.backgroundColor=[UIColor blackColor];
  self.searchField.alpha=0.7;
  self.searchField.textColor=[UIColor whiteColor];
  self.searchField.layer.cornerRadius=10;
  self.searchField.layer.masksToBounds=YES;
  
  self.tapView.backgroundColor=[UIColor blackColor];
  self.tapView.alpha=0.7;
  self.tapView.layer.cornerRadius=10;
  self.tapView.layer.masksToBounds=YES;
  
  self.scrollView.backgroundColor=[UIColor blackColor];
  self.scrollView.alpha=0.7;
  
  self.clearBtn.layer.cornerRadius=10;
  self.clearBtn.layer.masksToBounds=YES;
  
  self.createBtn.layer.cornerRadius=10;
  self.createBtn.layer.masksToBounds=YES;
  
  _locationViews=[[NSMutableArray alloc]init];
  
  [self.barView.rightButton setTitle:@"创建活动" forState:UIControlStateNormal];
  [self.barView.rightButton setTitle:@"创建活动" forState:UIControlStateHighlighted];
  self.barView.rightButton.frame=CGRectMake(240,6, 70,31);
  [self.barView.rightButton setHidden:NO];
  self.barView.titleLabel.text=@"画路线";
  _createInfo=[[MapCreateInfo alloc]init];
  [self.mapView setRegion:region animated:YES];
}

-(void)rightBtnClicked:(id)sender{
  [_HUD show:YES];
  _HUD.labelText=@"";
  if(!_succCreate){
    _HUD.mode = MBProgressHUDModeText;
    _HUD.labelText = @"生成路线以后才能创建活动~";
    _HUD.margin = 5.f;
    [_HUD hide:YES afterDelay:2];
    return;
  }
 _createInfo.coverImage=_newCoverImage;
   dispatch_async(dispatch_queue_create("drawRoutes", NULL), ^{
    NSString *key= [ImageUtil uploadPhotoToServerByImage:_createInfo.coverImage prefixPath:@"map" type:IMAGETYPE_MAP];
    dispatch_async(dispatch_get_main_queue(), ^{
      if(key==nil){
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"上传截图失败,请重新上传";
        _HUD.margin = 5.f;
        [_HUD hide:YES afterDelay:2];
      }
      _createInfo.urlKey=key;
      if(self.delegate){
        [self.delegate finishCreate:self info:_createInfo];
      }
      [_HUD setHidden:YES];
    });
  });

}

-(void)leftBtnClicked:(id)sender
{
  [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
  if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
    return;
	if([gestureRecognizer isMemberOfClass:[UILongPressGestureRecognizer class]] && (gestureRecognizer.state == UIGestureRecognizerStateEnded)) {
		[self.mapView removeGestureRecognizer:gestureRecognizer]; //avoid multiple pins to appear when holding on the screen
  }
   _HUD.mode = MBProgressHUDModeIndeterminate;
   _HUD.labelText=@"";
  [_HUD show:YES];
  CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
  CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
  MyAnnotation *annotation = [[MyAnnotation alloc]initWithLocation:touchMapCoordinate];
  CLLocation *location=[[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
  CLGeocoder *geoCoder=[[CLGeocoder alloc]init];
  [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
    for(CLPlacemark *mark in placemarks){
      annotation.title=mark.name;
      if(mark.locality){
        annotation.city=mark.locality;
      }else{
        annotation.city=annotation.title;
      }
      [self addNewAnnotation:annotation];
      break;
    }
  }];
}

#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
  self.route_view.hidden = YES;
}
//地图移动结束后的操作
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:line_color routes:_routes];
  self.route_view.hidden = NO;
  [self.route_view setNeedsDisplay];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
  // If it's the user location, just return nil.
  if ([annotation isKindOfClass:[MKUserLocation class]]){
    return nil;
  }
  // Handle any custom annotations.
  if ([annotation isKindOfClass:[MyAnnotation class]]){
    CreateAnnotationView* pinView  = [[CreateAnnotationView alloc] initWithAnnotation:annotation
                                                                      reuseIdentifier:@"CreateAnnotationView"];
    [pinView setPinColor:MKPinAnnotationColorGreen];
    [pinView setAnimatesDrop:YES];
    [pinView setCanShowCallout:YES];
    [pinView setDraggable:YES];
    pinView.delegate=self;
    pinView.annotation = annotation;
    return pinView;
  }
  
  return nil;
}

- (void)mapViewClick:(UITapGestureRecognizer*) gestureRecognize{
  UIView *view= gestureRecognize.view;
  if(![view isKindOfClass:[UITextField class]]){
    [_searchField resignFirstResponder];
  }
  [self hideAndDeleteAnnotation];
}

- (void)addNewAnnotation:(MyAnnotation*)annotation{
  if(self.tipsLabel){
    [self.tipsLabel removeFromSuperview];
  }
  _succCreate=FALSE;
  [self hideAndDeleteAnnotation];
  MKCoordinateRegion region;
  region.center=annotation.coordinate;
  region.span=self.mapView.region.span;
  [self.mapView setRegion:region animated:YES];
  [self.mapView addAnnotation:annotation];
  [self.mapView selectAnnotation:annotation animated:YES];
  _nowAnnotation=annotation;
  [self showTapView];
  [_HUD hide:YES];
}


- (void)addTapView:(LOCATIONTYPE)type{
  _nowAnnotation.checked=TRUE;
  LocationView *locationView=[[LocationView alloc]initWithFrame:CGRectMake([_locationViews count]*viewWidth, 0, viewWidth, viewHeight) type:type];
  locationView.latitude=_nowAnnotation.coordinate.latitude;
  locationView.longtitude=_nowAnnotation.coordinate.longitude;
  locationView.totalLocation=_nowAnnotation.title;
  locationView.annotation=_nowAnnotation;
  locationView.userInteractionEnabled=YES;
  UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationViewTap:)];
  [locationView addGestureRecognizer:tapGesture];
  [locationView setSubViews];
  switch (type) {
    case LOCATIONTYPE_BEGIN:
    {
      if([_locationViews count]>0){
        LocationView *view=[_locationViews objectAtIndex:0];
        if(view&&view.type==LOCATIONTYPE_BEGIN){
          [self.mapView removeAnnotation:view.annotation];
          [_locationViews removeObject:view];
        }
      }
      [_locationViews insertObject:locationView atIndex:0];
      [self reloadScrollView];
    }
      break;
    case LOCATIONTYPE_MID:
    {
      LocationView *view=[_locationViews lastObject];
      if(view&&view.type==LOCATIONTYPE_END){
        [_locationViews insertObject:locationView atIndex:([_locationViews count]-1)];
        [self reloadScrollView];
      }else{
        [_locationViews addObject:locationView];
        [self.scrollView addSubview:locationView];
      }
    }
      break;
    case LOCATIONTYPE_END:
    {
      LocationView *view=[_locationViews lastObject];
      if(view&&view.type==LOCATIONTYPE_END){
        [self.mapView removeAnnotation:view.annotation];
        [_locationViews removeLastObject];
        [_locationViews addObject:locationView];
        [self reloadScrollView];
        break;
      }
      [_locationViews addObject:locationView];
      [self.scrollView addSubview:locationView];
      
    }
      break;
    default:
      break;
  }
  self.scrollView.contentSize = CGSizeMake(viewWidth*[_locationViews count], viewHeight);
  [self hideTapView];
}

- (void)reloadScrollView{
  for(LocationView *view in self.scrollView.subviews){
    [view removeFromSuperview];
  }
  int index=0;
  for(LocationView *locationView in _locationViews){
    locationView.frame=CGRectMake(index*viewWidth, 0, viewWidth, viewHeight);
    [self.scrollView addSubview:locationView];
    self.scrollView.contentSize = CGSizeMake(viewWidth*[_locationViews count], viewHeight);
    index++;
  }
}

- (void)locationViewTap:(UIGestureRecognizer*)gesture{
  LocationView *locationView=(LocationView*)gesture.view;
  [self.mapView selectAnnotation:locationView.annotation animated:YES];
}

- (void)hideAndDeleteAnnotation{
  if(_nowAnnotation&&!_nowAnnotation.checked){
    [self.mapView removeAnnotation:_nowAnnotation];
    [self hideTapView];
  }
}


#pragma mark -
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  if(![textField.text isEqualToString:@""]){
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText=@"";
    [_HUD show:YES];
    CLGeocoder *geoCoder=[[CLGeocoder alloc]init];
    [geoCoder geocodeAddressString:textField.text completionHandler:^(NSArray *placemarks, NSError *error){
      if(placemarks){
        CLPlacemark *mark=[placemarks objectAtIndex:0];
        MyAnnotation *annotation = [[MyAnnotation alloc]initWithLocation:mark.location.coordinate];
        annotation.title=mark.name;
        if(mark.locality){
          annotation.city=mark.locality;
        }else{
          annotation.city=annotation.title;
        }
        [self addNewAnnotation:annotation];
      }else{
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"悲剧,没找到相关位置";
        _HUD.margin = 5.f;
        [_HUD hide:YES afterDelay:2];
      }
    }];
  }
  [textField resignFirstResponder];
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  _isSearching=TRUE;
  [textField setText:@""];
  return YES;
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}



#pragma mark IBAction
- (IBAction)beginClick:(id)sender{
  self.beginBtn.enabled=NO;
  [self addTapView:LOCATIONTYPE_BEGIN];
}
- (IBAction)midClick:(id)sender{
  self.midBtn.enabled=NO;
  [self addTapView:LOCATIONTYPE_MID];
}
- (IBAction)endClick:(id)sender{
  self.endBtn.enabled=NO;
  [self addTapView:LOCATIONTYPE_END];
}
- (IBAction)clearClick:(id)sender{
  self.createBtn.enabled=NO;
  for(LocationView *locationView in _locationViews){
    [self.mapView removeAnnotation:locationView.annotation];
    [locationView removeFromSuperview];
  }
  [_locationViews removeAllObjects];
  [_routes removeAllObjects];
  _nowAnnotation=nil;
  self.route_view.image=nil;
  self.createBtn.enabled=YES;
}
- (IBAction)createClick:(id)sender{
  [MobClick event:@"2012111902"];
  [self.mapView deselectAnnotation:_nowAnnotation animated:YES];
  _succCreate=FALSE;
  self.createBtn.enabled=NO;
  BOOL succ=FALSE;
  if([_locationViews count]>=2){
    LocationView *beginView=[_locationViews objectAtIndex:0];
    LocationView *endView=[_locationViews lastObject];
    if(beginView.type==LOCATIONTYPE_BEGIN&&endView.type==LOCATIONTYPE_END){
      succ=TRUE;
    }
  }
  [_HUD show:YES];
  if(!succ){
    _HUD.mode = MBProgressHUDModeText;
    _HUD.labelText = @"必须要有起点终点噢!^_^";
    _HUD.margin = 5.f;
    [_HUD hide:YES afterDelay:2];
    self.createBtn.enabled=YES;
    return;
  }
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  NSMutableArray *locationArray=[[NSMutableArray alloc]initWithCapacity:[_locationViews count]];
  NSMutableArray *nameArray=[[NSMutableArray alloc]init];
  int index=0;
  for(LocationView *view in _locationViews){
    if(index!=0&&index!=[_locationViews count]-1){
      [nameArray addObject:view.totalLocation];
    }
    [locationArray addObject:[NSString stringWithFormat:@"%f,%f",view.latitude,view.longtitude]];
  }
  _createInfo.midLocations=nameArray;
  _createInfo.beginLocation=((LocationView*)[_locationViews objectAtIndex:0]).totalLocation;
  _createInfo.endLocation=((LocationView*)[_locationViews lastObject]).totalLocation;
  _createInfo.mapTaps=locationArray;
  _createInfo.cityName=((LocationView*)[_locationViews objectAtIndex:0]).annotation.city;
  self.route_view.image=nil;
  [_routes removeAllObjects];
  dispatch_async(dispatch_queue_create("drawRoutes", NULL), ^{
    line_color = [UIColor getColor:lineColor];
    [[MapUtil getSinglton] calculate_routes_from:locationArray map_dic:dic];
    NSArray *array = [dic objectForKey:@"points"];
    _routes = [[MapUtil getSinglton] decodePolyLineArray:array];
    _createInfo.points=array;
    _createInfo.distance=[[dic objectForKey:@"distance"] intValue];
    dispatch_async(dispatch_get_main_queue(), ^{
      [_HUD hide:YES];
      if(self){
        [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:line_color routes:_routes];
        if([_routes count]>0){
          [[MapUtil getSinglton] center_map:self.mapView routes:_routes];
          _succCreate=TRUE;
          UIGraphicsBeginImageContext(self.coverImageView.frame.size); //currentView 当前的view
          [self.coverImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
          _newCoverImage = UIGraphicsGetImageFromCurrentImageContext();
          UIGraphicsEndImageContext();
        }else{
          _HUD.mode = MBProgressHUDModeText;
          _HUD.labelText = @"生成失败,google的网络不太好,再来一次吧^_^!!";
          _HUD.labelFont=[UIFont systemFontOfSize:14];
          _HUD.margin = 5.f;
          [_HUD hide:YES afterDelay:2];
          [MobClick event:@"2012111907"];
        }
      }
      self.createBtn.enabled=YES;
    });
  });
}
#pragma mark TapView
- (void)showTapView{
  if(!self.tapView.hidden){
    return;
  }
  self.tapView.hidden=NO;
  self.beginBtn.enabled=YES;
  self.midBtn.enabled=YES;
  self.endBtn.enabled=YES;
}

- (void)hideTapView{
  if(self.tapView.hidden){
    return;
  }
  self.tapView.hidden=YES;
  self.beginBtn.enabled=NO;
  self.midBtn.enabled=NO;
  self.endBtn.enabled=NO;
  
}
#pragma mark CreateAnnotationView delegate
-(void)imageViewDelete:(CreateAnnotationView*)view{
  _succCreate=FALSE;
  MyAnnotation *annotation=view.annotation;
  [self.mapView removeAnnotation:annotation];
  BOOL findView=FALSE;  
  for(LocationView *locationView in _scrollView.subviews){
    if(locationView.annotation == annotation){
      [locationView removeFromSuperview];
       [_locationViews removeObject:locationView];
      findView=TRUE;
    }
    if(findView){
      CGRect frame=locationView.frame;
      frame.origin.x=frame.origin.x-frame.size.width;
      locationView.frame=frame;
    }
  }
 
}

@end
