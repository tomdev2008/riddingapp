//
//  FirstAnnotation.h
//  Ridding
//
//  Created by zys on 13-2-21.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FirstAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *city;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;
@end
