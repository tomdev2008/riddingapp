//
//  MapSearchVCTL.h
//  Ridding
//
//  Created by zys on 12-12-26.
//
//

#import "BasicViewController.h"
#import <MapKit/MapKit.h>

@class MapSearchVCTL;

@protocol MapSearchVCTLDelegate <NSObject>

- (void)didSelectPlaceMarks:(MapSearchVCTL *)mapSearchVCTL placemark:(CLPlacemark *)placemark;

@end


@interface MapSearchVCTL : BasicViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
  NSMutableArray *_placemarks;
}

@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, assign) id <MapSearchVCTLDelegate> delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil placemarks:(NSArray *)placemarks;
@end
