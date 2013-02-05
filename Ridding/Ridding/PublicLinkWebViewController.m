//
//  PublicLinkWebViewController.m
//  Ridding
//
//  Created by zys on 13-2-5.
//
//

#import "PublicLinkWebViewController.h"
#import "SVProgressHUD.h"
@interface PublicLinkWebViewController ()

@end

@implementation PublicLinkWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString*)url{
  
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _url=url;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  self.barView.leftButton.hidden = NO;

  NSURLRequest *loginRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
  [self.web loadRequest:loginRequest];

}

- (void)leftBtnClicked:(id)sender {
  
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  
  [SVProgressHUD showWithStatus:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
  [SVProgressHUD dismiss];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  return YES;
}

@end
