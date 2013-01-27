//
//  MapUtil.h
//  Ridding
//
//  Created by zys on 12-3-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h> 
#import <CoreLocation/CoreLocation.h> 
#import "ASIHTTPRequest.h"
#import "SBJSON.h"
@interface MapUtil : NSObject{
 
}

+ (MapUtil*)getSinglton;

//通过服务端得到的地图点array计算出来经纬度array
-(void)calculate_routes_from:(NSArray*)mapLoactions map:(Map*)map;
//将地图在这些点居中显示
-(void) center_map:(MKMapView *)mapView routes:(NSArray*)routes;
//更新地图，画线
-(void)update_route_view:(MKMapView *)mapView to:(UIImageView *)route_view line_color:(UIColor*)line_color routes:(NSArray*)routes;
//对google得到的内容做反编译，声称经纬度的点
-(NSMutableArray *)decodePolyLine:(NSMutableString *)encoded;

-(NSMutableArray*)decodePolyLineArray:(NSArray*)pointArray;

-(NSDictionary*)getResponFromGoogle:(NSString *)saddr to:(NSString *)daddr;

-(NSString*)getPoints:(NSDictionary*) dic_data;

-(NSArray*)getToNextDistance:(NSDictionary*) dic_data;

-(int)getTotalDistance:(NSDictionary*) dic_data;

-(NSArray*)getStartLocation:(NSDictionary*) dic_data;
@end
