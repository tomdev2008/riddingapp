//
//  QQNRFeedTableCell.h
//  Ridding
//
//  Created by zys on 12-9-27.
//
//

#import <UIKit/UIKit.h>
#include "ActivityInfo.h"
#import "SWSnapshotStackView.h"
#import "RequestUtil.h"

@class QQNRFeedTableCell;

@protocol QQNRFeedTableCellDelegate <NSObject>
- (void)leaderTap:(QQNRFeedTableCell *)cell;

- (void)statusTap:(QQNRFeedTableCell *)cell;

@end

@interface QQNRFeedTableCell : UITableViewCell {
}

@property (nonatomic, assign) id <QQNRFeedTableCellDelegate> delegate;
@property (nonatomic) int index;

@property (nonatomic, retain) IBOutlet UIButton *avatorBtn;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *teamCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UIImageView *mapLineView;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIImageView *avatorBgView;
@property (nonatomic, retain) IBOutlet UIButton *statusBtn;


- (void)initContentView:(Ridding *)ridding;

- (void)drawRoutes:(NSArray *)routes riddingId:(long long)riddingId;

@end
