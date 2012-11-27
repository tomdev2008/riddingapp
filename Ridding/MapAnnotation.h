//
//  MapAnnotation.h
//  Ridding
//
//  Created by Wu Chenhao on 5/27/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

-(id) initWithCoords:(CLLocationCoordinate2D) coords; 

@end
