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
#import "MapUtil.h"
#import "RiddingLocationDao.h"
#import "UIButton+WebCache.h"

#define frameSize @"28"

@implementation PublicDetailHeaderView

- (id)initWithFrame:(CGRect)frame ridding:(Ridding *)ridding isMyHome:(BOOL)isMyHome {

  self = [super initWithFrame:frame];
  if (self) {
    _ridding = ridding;
    _isMyHome = isMyHome;
    self.backgroundColor = [UIColor clearColor];


    UIButton *avatorBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 55, 55)];
    NSURL *url = [NSURL URLWithString:_ridding.leaderUser.savatorUrl];
    [avatorBtn setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
    avatorBtn.showsTouchWhenHighlighted = YES;
    [avatorBtn addTarget:self action:@selector(avatorClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:avatorBtn];

    UILabel *riddingNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 250, 30)];
    riddingNameLabel.textColor = [UIColor whiteColor];
    riddingNameLabel.textAlignment = UITextAlignmentLeft;
    riddingNameLabel.text = _ridding.riddingName;
    riddingNameLabel.backgroundColor = [UIColor clearColor];
    riddingNameLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:riddingNameLabel];

    UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 50, 75, 15)];
    createLabel.textColor = [UIColor whiteColor];
    createLabel.textAlignment = UITextAlignmentLeft;
    createLabel.text = [NSString stringWithFormat:@"%@", _ridding.createTimeStr];
    createLabel.backgroundColor = [UIColor clearColor];
    createLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:createLabel];


    NSString *dictance = [NSString stringWithFormat:@"%0.2fKM", _ridding.map.distance * 1.0 / 1000];;
    CGSize linesSz = [dictance sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(100, 25) lineBreakMode:(NSLineBreakMode) UILineBreakModeCharacterWrap];

    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 50, linesSz.width, linesSz.height + 2)];
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.textAlignment = UITextAlignmentCenter;
    distanceLabel.text = dictance;
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.font = [UIFont systemFontOfSize:12];


    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(distanceLabel.frame.origin.x - 13, distanceLabel.frame.origin.y, 12, 14)];
    iconImage.image = UIIMAGE_FROMPNG(@"QQNR_PD_DistancePic");

    UIImageView *distanceViewBG = [[UIImageView alloc] initWithFrame:CGRectMake(distanceLabel.frame.origin.x - 15, distanceLabel.frame.origin.y, distanceLabel.frame.size.width + 20, distanceLabel.frame.size.height)];
    distanceViewBG.image = [UIIMAGE_FROMPNG(@"QQNR_PD_DistanceBg") stretchableImageWithLeftCapWidth:4 topCapHeight:10];

    [self addSubview:distanceViewBG];
    [self addSubview:iconImage];
    [self addSubview:distanceLabel];

    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(15, 85, 280, 140)];
    _route_view = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, 290, 150)];
    _route_view.layer.borderColor = [[UIColor whiteColor] CGColor];
    _route_view.layer.borderWidth = 5.0;
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
      Map *map = [[Map alloc] initWithJSONDic:[map_dic objectForKey:keyMap]];
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
