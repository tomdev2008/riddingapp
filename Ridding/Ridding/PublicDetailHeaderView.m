//
//  PublicDetailHeaderView.m
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import "PublicDetailHeaderView.h"
#import "UIImageView+WebCache.h"
#import "UIColor+XMin.h"
#import "RequestUtil.h"
#import "MapUtil.h"
#import "RiddingLocationDao.h"

#define frameSize @"28"

@implementation PublicDetailHeaderView

- (id)initWithFrame:(CGRect)frame ridding:(Ridding *)ridding isMyHome:(BOOL)isMyHome {

  self = [super initWithFrame:frame];
  if (self) {
    _ridding = ridding;
    _isMyHome = isMyHome;
    self.backgroundColor = [UIColor clearColor];


    UIImageView *avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 55, 55)];
    NSURL *url = [NSURL URLWithString:_ridding.leaderUser.savatorUrl];
    [avatorImageView setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
    [self addSubview:avatorImageView];

    UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maskBtn.frame = CGRectMake(15, 15, 55, 55);
    [maskBtn setImage:UIIMAGE_FROMPNG(@"PublicView_Head") forState:UIControlStateNormal];
    [maskBtn setImage:UIIMAGE_FROMPNG(@"PublicView_Head") forState:UIControlStateHighlighted];
    maskBtn.showsTouchWhenHighlighted = YES;
    [maskBtn addTarget:self action:@selector(avatorClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maskBtn];

    UILabel *riddingNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 250, 30)];
    riddingNameLabel.textColor = [UIColor getColor:barTextColor];
    riddingNameLabel.textAlignment = UITextAlignmentLeft;
    riddingNameLabel.text = _ridding.riddingName;
    riddingNameLabel.backgroundColor = [UIColor clearColor];
    riddingNameLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:riddingNameLabel];


    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 45, 200, 15)];
    distanceLabel.textColor = [UIColor getColor:barTextColor];
    distanceLabel.textAlignment = UITextAlignmentLeft;
    distanceLabel.text = [NSString stringWithFormat:@"行程 : %0.2fKM", _ridding.map.distance * 1.0 / 1000];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:distanceLabel];

    UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 60, 200, 15)];
    createLabel.textColor = [UIColor getColor:barTextColor];
    createLabel.textAlignment = UITextAlignmentLeft;
    createLabel.text = [NSString stringWithFormat:@"创建时间: %@", _ridding.createTimeStr];
    createLabel.backgroundColor = [UIColor clearColor];
    createLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:createLabel];

    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(15, 80, 290, 200)];
    _route_view = [[UIImageView alloc] initWithFrame:CGRectMake(15, 80, 290, 200)];
    [_mapView setShowsUserLocation:NO];
    _mapView.delegate = self;
    [_mapView setZoomEnabled:NO];
    [_mapView setScrollEnabled:NO];
    if (_isMyHome && ![_ridding isEnd]) {
      UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTap:)];
      _mapView.userInteractionEnabled = YES;
      [_mapView addGestureRecognizer:tapGesture];
    }

    [self addSubview:_mapView];
    [self addSubview:_route_view];
    _routes = [[NSMutableArray alloc] init];
    [self drawRoutes];
  }
  return self;
}

- (void)drawRoutes {

  dispatch_queue_t q;
  q = dispatch_queue_create("drawRoutes", NULL);
  dispatch_async(q, ^{
    NSArray *routeArray = [RiddingLocationDao getRiddingLocations:_ridding.riddingId beginWeight:0];
    if ([routeArray count] > 0) {
      for (RiddingLocation *location in routeArray) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longtitude];
        [_routes addObject:loc];
      }
    } else {
      //如果数据库中存在，那么取数据库中的地图路径，如果不存在，http去请求服务器。
      //数据库中取出是mapTaps或者points
      RequestUtil *requestUtil = [[RequestUtil alloc] init];
      NSMutableDictionary *map_dic = [requestUtil getMapMessage:_ridding.riddingId userId:[StaticInfo getSinglton].user.userId];
      Map *map = [[Map alloc] initWithJSONDic:[map_dic objectForKey:@"map"]];
      NSArray *array = map.mapPoint;
      [[MapUtil getSinglton] calculate_routes_from:map.mapTaps map:map];
      _routes = [[MapUtil getSinglton] decodePolyLineArray:array];
      [RiddingLocationDao setRiddingLocationToDB:_routes riddingId:_ridding.riddingId];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [[MapUtil getSinglton] center_map:_mapView routes:_routes];
      [[MapUtil getSinglton] update_route_view:_mapView to:_route_view line_color:[UIColor getColor:lineColor] routes:_routes];
    });
  });
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {

  _route_view.hidden = YES;
}

//地图移动结束后的操作
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

  [[MapUtil getSinglton] update_route_view:_mapView to:_route_view line_color:[UIColor getColor:lineColor] routes:_routes];
  _route_view.hidden = NO;
  [_route_view setNeedsDisplay];
}

- (void)mapViewTap:(UIGestureRecognizer *)gesture {

  if (self.delegate) {
    [self.delegate mapViewTap:self];
  }
}

- (void)avatorClick:(id)selector {

  if (self.delegate) {
    [self.delegate avatorClick:self];
  }
}


@end
