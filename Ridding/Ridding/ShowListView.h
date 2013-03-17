//
//  ShowListView.h
//  Ridding
//
//  Created by zys on 13-3-17.
//
//

#import <UIKit/UIKit.h>
@class ShowListView;
@protocol ShowListViewDelegate <NSObject>

- (void)picClick:(ShowListView*)view;
- (void)weatherClick:(ShowListView*)view;
- (void)settingClick:(ShowListView*)view;

@end

@interface ShowListView : UIView

@property (nonatomic,retain) IBOutlet UIImageView *picBgView;
@property (nonatomic,retain) IBOutlet UIImageView *picImageView;
@property (nonatomic,retain) IBOutlet UILabel *picLabel;

@property (nonatomic,retain) IBOutlet UIImageView *weatherBgView;
@property (nonatomic,retain) IBOutlet UIImageView *weatherImageView;
@property (nonatomic,retain) IBOutlet UILabel *weatherLabel;

@property (nonatomic,assign) id<ShowListViewDelegate> delegate;


- (void)reset;

@end
