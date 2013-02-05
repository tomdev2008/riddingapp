//
//  PublicDetailHeaderView.h
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import <UIKit/UIKit.h>
#import "Ridding.h"
#import <MapKit/MapKit.h>

@class PublicDetailHeaderView;

@protocol PublicDetailHeaderDelegate <NSObject>

- (void)mapViewTap:(PublicDetailHeaderView *)view;

- (void)avatorClick:(PublicDetailHeaderView *)view;

- (void)linkTap:(PublicDetailHeaderView *)view;
@end

@interface PublicDetailHeaderView : UIView <MKMapViewDelegate> {
  Ridding *_ridding;
  MKMapView *_mapView;
  NSMutableArray *_routes;
  UIImageView *_route_view;
  BOOL _isMyHome;
  UILabel *_adLabel;
  UIImageView *_adImageView;
}

@property (nonatomic, assign) id <PublicDetailHeaderDelegate> delegate;

- (id)initWithFrame:(CGRect)frame ridding:(Ridding *)ridding isMyHome:(BOOL)isMyHome;
@end
