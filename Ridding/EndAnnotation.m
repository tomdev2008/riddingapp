//
//  EndAnnotation.m
//  Ridding
//
//  Created by Wu Chenhao on 5/27/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import "EndAnnotation.h"

@implementation EndAnnotation

@synthesize coordinate, subtitle, title;

- (id)initWithCoords:(CLLocationCoordinate2D)coords {

  self = [super init];

  if (self != nil) {

    coordinate = coords;

  }

  return self;
}


@end
