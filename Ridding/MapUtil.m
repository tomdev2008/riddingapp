//
//  MapUtil.m
//  Ridding
//
//  Created by zys on 12-3-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapUtil.h"
#import "Map.h"
static MapUtil *mapUtil=nil;
@implementation MapUtil
- (id)init
{
  self = [super init];
  if (self) {
  }
  
  return self;
}

+ (MapUtil*)getSinglton
{
  @synchronized(self) {
    if (mapUtil == nil) {
      mapUtil=[[self alloc] init];
    }
  }
  return mapUtil;
}

//得到point的array
-(void)calculate_routes_from:(NSArray*)mapLoactions map:(Map*)map{
  if (!mapLoactions||[mapLoactions count]==0) {
    return;
  }
  NSMutableArray *mulpoint=[[NSMutableArray alloc]init];
  NSMutableArray *mulToNextDistance=[[NSMutableArray alloc]init];
  NSMutableArray *mulStartLocations=[[NSMutableArray alloc]init];
  NSString* saddr;
  NSString* daddr;
  NSString* point;
  int distance=0;
  NSDictionary* response;
  bool succ=true;
  for (int i=1;i<[mapLoactions count];i++) {
    saddr=[mapLoactions objectAtIndex:i-1];
    daddr=[mapLoactions objectAtIndex:i];
    response=[self getResponFromGoogle:saddr to:daddr];
    if(response==nil){
      succ=false;
      break;
    }
    point=[self getPoints:response];
    [mulpoint addObject:point];
    distance+=[self getTotalDistance:response];
#warning 这两个可能不要了
    [mulToNextDistance addObjectsFromArray:[self getToNextDistance:response]];
    [mulStartLocations addObjectsFromArray:[self getStartLocation:response]];
  }
  if(!succ){
    return;
  }
  map.toNextDistance=mulToNextDistance;
  map.mapPoint=mulpoint;
  map.distance=distance;
  map.startLocations=mulStartLocations;
}
//通过经纬度返回值得到距离
-(int)getTotalDistance:(NSDictionary*) dic_data{
  NSArray *dic_routes=[dic_data objectForKey:@"routes"];
  NSDictionary *legs=[dic_routes objectAtIndex:0];
  NSArray *leg=[legs objectForKey:@"legs"];
  int distance=0;
  if(leg&&[leg count]>0){
    for(NSDictionary *dictanceDic in leg){
      NSDictionary* dic=[dictanceDic objectForKey:@"distance"];
      distance+=[[dic objectForKey:@"value"] intValue];
    }
  }
  return distance;
}
//插入polyline的点
-(NSString*)getPoints:(NSDictionary*) dic_data{
  NSArray *dic_routes=[dic_data objectForKey:@"routes"];
  NSDictionary *legs=[dic_routes objectAtIndex:0];
  NSDictionary *points=[legs objectForKey:@"overview_polyline"];    return [points objectForKey:@"points"];
}
//插入下一个点
-(NSArray*)getToNextDistance:(NSDictionary*) dic_data{
  NSArray *dic_routes=[dic_data objectForKey:@"routes"];
  NSDictionary *legs=[dic_routes objectAtIndex:0];
  NSArray *leg=[legs objectForKey:@"legs"];
  NSDictionary *step=[leg objectAtIndex:0];
  NSArray *steps=[step objectForKey:@"steps"];
  NSMutableArray *toNextDistances=[[NSMutableArray alloc]init];
  if(steps&&[steps count]>0){
    for(NSDictionary *dictanceDic in steps){
      NSDictionary* dic=[dictanceDic objectForKey:@"distance"];
      [toNextDistances addObject:[dic objectForKey:@"value"]];
    }
  }
  return toNextDistances;
}

//插入下一个点
-(NSArray*)getStartLocation:(NSDictionary*) dic_data{
  NSArray *dic_routes=[dic_data objectForKey:@"routes"];
  NSDictionary *legs=[dic_routes objectAtIndex:0];
  NSArray *leg=[legs objectForKey:@"legs"];
  NSDictionary *step=[leg objectAtIndex:0];
  NSArray *steps=[step objectForKey:@"steps"];
  NSMutableArray *startLocation=[[NSMutableArray alloc]init];
  if(steps&&[steps count]>0){
    for(NSDictionary *dictanceDic in steps){
      NSDictionary* dic=[dictanceDic objectForKey:@"start_location"];
      CLLocation *location=[[CLLocation alloc]initWithLatitude:[[dic objectForKey:@"lat"] doubleValue]  longitude:[[dic objectForKey:@"lng"] doubleValue]];
      [startLocation addObject:location];
    }
  }
  return startLocation;
}

//对point的array进行解析
-(NSMutableArray*)decodePolyLineArray:(NSArray*)pointArray{
  NSMutableArray* mulArray=[[NSMutableArray alloc]init];
  NSArray* array;
  if (pointArray&&[pointArray count]>0) {
    for (NSString *string in pointArray) {
      array=[self decodePolyLine:[string mutableCopy]];
      [mulArray addObjectsFromArray:array];
    }
  }
  return mulArray;
}

//从google那里得到返回值
-(NSDictionary*)getResponFromGoogle:(NSString *)saddr to:(NSString *)daddr{
  saddr=[saddr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  daddr=[daddr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSString* apiUrlStr=[NSString stringWithFormat:@"http://ditu.google.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true&mode=walking",saddr,daddr];
  NSURL *apiUrl=[NSURL URLWithString:apiUrlStr];
  ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:apiUrl];
  [request startSynchronous];
  if([request responseStatusCode]!=200){
    return nil;
  }
  NSString* apiResponse=[request responseString];
  return [apiResponse JSONValue];
}


//解析googleapi传过来的地址
-(NSMutableArray *)decodePolyLine:(NSMutableString *)encoded{
  NSInteger len=[encoded length];
  NSInteger index=0;
  NSMutableArray *array=[[NSMutableArray alloc]init];
  NSInteger lat=0;
  NSInteger lng=0;
  while (index<len) {
    NSInteger b;
    NSInteger shift=0;
    NSInteger result=0;
    do{
      b=[encoded characterAtIndex:index++]-63;
      result |=(b&0x1f)<<shift;
      shift+=5;
    }while (b>=0x20);
    NSInteger dlat=((result & 1)?~(result>>1):(result>>1));
    lat+=dlat;
    shift=0;
    result=0;
    do {
      b=[encoded characterAtIndex:index++]-63;
      result |=(b&0x1f)<<shift;
      shift+=5;
    } while (b>=0x20);
    NSInteger dlng=((result & 1)?~(result>>1):(result>>1));
    lng+=dlng;
    NSNumber *latitude=[[NSNumber alloc]initWithFloat:lat*1e-5];
    NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng *1e-5];
    printf("[%f,", [latitude doubleValue]);
    printf("%f]", [longitude doubleValue]);
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
    [array addObject:loc];
  }
  return array;
}
//显示地图的中心位置，这样可以显示所有路线在中间
-(void) center_map:(MKMapView *)mapView routes:(NSArray*)routes{
  MKCoordinateRegion region;
  CLLocationDegrees maxLat=-90;
  CLLocationDegrees maxLon=-180;
  CLLocationDegrees minLat=90;
  CLLocationDegrees minLon=180;
  if([routes count]==0){
    return ;
  }
  for (int idx=0; idx<routes.count; idx++) {
    CLLocation* currentLocation=[routes objectAtIndex:idx];
    if (currentLocation.coordinate.latitude>maxLat) {
      maxLat=currentLocation.coordinate.latitude;
    }
    if (currentLocation.coordinate.latitude<minLat) {
      minLat=currentLocation.coordinate.latitude;
    }
    if (currentLocation.coordinate.longitude>maxLon) {
      maxLon=currentLocation.coordinate.longitude;
    }
    if (currentLocation.coordinate.longitude<minLon) {
      minLon=currentLocation.coordinate.longitude;
    }
  }
  region.center.latitude=(maxLat+minLat)/2;
  region.center.longitude=(maxLon+minLon)/2;
  region.span.latitudeDelta=maxLat-minLat;
  region.span.longitudeDelta=maxLon-minLon;
  [mapView setRegion:region];
}


//对经纬度的array画线
-(void)update_route_view:(MKMapView *)mapView to:(UIImageView *)route_view line_color:(UIColor*)line_color routes:(NSArray*)routes{
  CGContextRef context =CGBitmapContextCreate(nil, route_view.frame.size.width, route_view.frame.size.height, 8, 4*route_view.frame.size.width, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);
  CGContextSetStrokeColorWithColor(context, line_color.CGColor);
  CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
  CGContextSetLineWidth(context, 5.0);
  for (int i=0; i<routes.count; i++) {
    CLLocation* location_=[routes objectAtIndex:i];
    CGPoint point=[mapView convertCoordinate:location_.coordinate toPointToView:route_view];
    if (i==0) {
      CGContextMoveToPoint(context, point.x, route_view.frame.size.height-point.y);
    }else{
      CGContextAddLineToPoint(context, point.x, route_view.frame.size.height-point.y);
    }
  }
  
  CGContextStrokePath(context);
  CGImageRef image=CGBitmapContextCreateImage(context);
  UIImage *uiImage=[UIImage imageWithCGImage:image];
  if(uiImage){
     [route_view setImage:uiImage];
  }
  CGImageRelease(image);
  CGContextRelease(context);
}



@end
