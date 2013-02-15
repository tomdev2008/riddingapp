//
//  Annotation.h
//  Ridding
//
//  Created by zys on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
typedef enum MyAnnotationType {
  MyAnnotationType_BEGIN = 1,
  MyAnnotationType_MID = 2,
  MyAnnotationType_END = 3,
} MyAnnotationType;

@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *city;
@property (nonatomic) BOOL checked;
@property (nonatomic) MyAnnotationType type;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
