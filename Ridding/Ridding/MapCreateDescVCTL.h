//
//  MapCreateDescVCTL.h
//  Ridding
//
//  Created by zys on 12-11-17.
//
//

#import "BasicViewController.h"
#import "MapCreateInfo.h"
#import "SVSegmentedControl.h"
#import "Map.h"
#import "QQNRServerTask.h"

@interface MapCreateDescVCTL : BasicViewController <UITextFieldDelegate, QQNRServerTaskDelegate> {
  Ridding *_ridding;
  UIButton *_syncSinaBtn;
  BOOL _showingKeyBoard;
}

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *beginLocationTV;
@property (nonatomic, retain) IBOutlet UITextField *endLocationTV;
@property (nonatomic, retain) IBOutlet UILabel *totalDistanceLB;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIImageView *lineImageView;
@property (nonatomic, retain) IBOutlet UIImageView *separatorLine1;
@property (nonatomic, retain) IBOutlet UIImageView *separatorLine2;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ridding:(Ridding *)ridding;
@end
