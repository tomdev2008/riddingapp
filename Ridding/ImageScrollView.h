//
//  ImageScrollView.h
//  BabyCare
//
//  Created by Tom on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchedScrollView.h"
#import "RiddingPicture.h"
@interface ImageScrollView : TouchedScrollView <UIScrollViewDelegate> {
    
    UIImageView        *imageView;
    NSUInteger     index;

}

@property (assign) NSUInteger index;

- (void)displayImage:(RiddingPicture *)image;
- (void)loadOtherImage:(RiddingPicture*)imageInfo;
@end
