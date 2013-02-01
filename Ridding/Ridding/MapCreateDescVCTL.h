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

@interface MapCreateDescVCTL : BasicViewController <UITextFieldDelegate, UITextViewDelegate, QQNRServerTaskDelegate> {
  Ridding *_ridding;
  SVSegmentedControl *_redSC;
  SVSegmentedControl *_publicSC;
  UIButton *_syncSinaBtn;
  BOOL _sendWeiBo;
  BOOL _isPublic;
  BOOL _showingKeyBoard;
  BOOL _isSyncSina;
}

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextView *beginLocationTV;
@property (nonatomic, retain) IBOutlet UITextView *endLocationTV;
@property (nonatomic, retain) IBOutlet UILabel *totalDistanceLB;
@property (nonatomic, retain) IBOutlet UIImageView *mapImageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ridding:(Ridding *)ridding;
@end
