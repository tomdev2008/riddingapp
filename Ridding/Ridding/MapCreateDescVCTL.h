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
@class MapCreateDescVCTL;
@protocol MapCreateDescVCTLDelegate <NSObject>

- (void)finishCreate:(MapCreateDescVCTL*)controller ;

@end

@interface MapCreateDescVCTL : BasicViewController<UITextFieldDelegate>{
  Map *_map;
  SVSegmentedControl *_redSC;
  BOOL _sendWeiBo;
}

@property(nonatomic,retain) IBOutlet UITextField *nameField;
@property(nonatomic,retain) IBOutlet UILabel *beginLocationLB;
@property(nonatomic,retain) IBOutlet UILabel *endLocationLB;
@property(nonatomic,retain) IBOutlet UILabel *totalDistanceLB;
@property(nonatomic,retain) IBOutlet UIImageView *mapImageView;

@property(nonatomic,assign) id<MapCreateDescVCTLDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil info:(Map*)info;
@end
