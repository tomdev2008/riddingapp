//
//  MapSearchCell.h
//  Ridding
//
//  Created by zys on 13-2-19.
//
//

#import <UIKit/UIKit.h>

@interface MapSearchCell : UITableViewCell


@property (nonatomic,retain) IBOutlet UILabel *locationLabel;

- (void)initView:(NSString*)location;

@end
