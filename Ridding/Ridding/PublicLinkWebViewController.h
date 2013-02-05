//
//  PublicLinkWebViewController.h
//  Ridding
//
//  Created by zys on 13-2-5.
//
//

#import <UIKit/UIKit.h>

@interface PublicLinkWebViewController : BasicViewController <UIWebViewDelegate>{
  NSString *_url;
}


@property (nonatomic, retain) IBOutlet UIWebView *web;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString*)url;
@end
