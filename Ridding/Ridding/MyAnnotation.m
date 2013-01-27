//
//  Annotation.m
//  Ridding
//
//  Created by zys on 12-11-15.
//
//

#import "MyAnnotation.h"

@implementation MyAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D)coord {

  self = [super init];
  if (self) {
    self.coordinate = coord;
    self.checked = FALSE;
  }
  return self;
}

//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
//  self.coordinate = newCoordinate;
//}

@end
