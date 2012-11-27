//
//  PhotoDescViewController.h
//  Ridding
//
//  Created by zys on 12-10-30.
//
//

#import "BasicViewController.h"
#import "RiddingPicture.h"
#import "SWSnapshotStackView.h"
#import <MapKit/MapKit.h>
@interface PhotoDescViewController : BasicViewController{
  UIImage *_image;
  NSNumber *_dbId;
  CLLocation *_location;
}

@property(nonatomic,retain) IBOutlet SWSnapshotStackView *imageView;
@property(nonatomic,retain) IBOutlet UITextView *textView;
@property(nonatomic,retain) IBOutlet UILabel *locationLabel;
@property(nonatomic,retain) IBOutlet UILabel *timeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil info:(NSDictionary*)info;

@end
