//
//  BasicLeftViewCell.h
//  Ridding
//
//  Created by zys on 13-1-22.
//
//

#import <UIKit/UIKit.h>

@interface BasicLeftViewCell : UITableViewCell


@property (nonatomic, retain) IBOutlet UIImageView *backgroundColorView;
@property (nonatomic, retain) IBOutlet UIView *leftColorView;
@property (nonatomic, retain) IBOutlet UIImageView *iconView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;


- (void)selected;

- (void)disSelected;
@end
