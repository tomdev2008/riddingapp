//
//  PhtotAnnotation.m
//  Ridding
//
//  Created by zys on 12-10-13.
//
//

#import "PhotoAnnotation.h"
@interface PhotoAnnotation()

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@end

@implementation PhotoAnnotation
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize image=_image;
@synthesize index=_index;
- (id)initWithLatitude:(CLLocationDegrees)latitude
andLongitude:(CLLocationDegrees)longitude {
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	self.latitude = newCoordinate.latitude;
	self.longitude = newCoordinate.longitude;
}


@end
