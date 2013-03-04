//
//  FirstAnnotation.m
//  Ridding
//
//  Created by zys on 13-2-21.
//
//

#import "FirstAnnotation.h"

@implementation FirstAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
  
  self = [super init];
  if (self) {
    self.coordinate = coord;
  }
  return self;
}

@end
