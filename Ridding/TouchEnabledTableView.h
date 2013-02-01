//
//  TouchEnabledTableView.h
//  MyBabyCare
//
//  Created by Tom on 2/1/12.
//  Copyright (c) 2012 儒果网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchEnabledTableView;

@protocol TouchEnabledTableViewDelegate <NSObject>

- (void)onTableView:(TouchEnabledTableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)onTableView:(TouchEnabledTableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)onTableView:(TouchEnabledTableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)onTableView:(TouchEnabledTableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface TouchEnabledTableView : UITableView {

  id <TouchEnabledTableViewDelegate> touchDelegate;

}

@property (nonatomic, assign) id <TouchEnabledTableViewDelegate> touchDelegate;
@property (nonatomic) BOOL touchDisabled;

@end
