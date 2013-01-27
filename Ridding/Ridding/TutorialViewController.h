//
//  TutorialViewController.h
//  Ridding
//
//  Created by Wu Chenhao on 5/8/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSwipeViewController.h"

@interface TutorialViewController : UIViewController <ImageSwipeViewDelegate> {
  NSArray *imageList;
  ImageSwipeViewController *imageSwipeViewController;
}

@property (strong, nonatomic) IBOutlet UIImageView *tutorialImage;
@property (strong, nonatomic) NSArray *imageList;


@end
