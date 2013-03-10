//
//  WeatherAnnotation.h
//  Ridding
//
//  Created by zys on 13-3-10.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h> 
#import "Weather.h"
@interface WeatherAnnotation : NSObject <MKAnnotation>{
}


@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) UIImage *headImage;
@property (nonatomic,retain) Weather *weather;
@end
