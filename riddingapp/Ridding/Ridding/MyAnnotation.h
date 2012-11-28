//
//  Annotation.h
//  Ridding
//
//  Created by zys on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyAnnotation :NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *city;
@property (nonatomic) BOOL checked;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
