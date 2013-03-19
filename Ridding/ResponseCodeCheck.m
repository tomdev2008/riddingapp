//
//  ResponseCodeCheck.m
//  Ridding
//
//  Created by zys on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Reachability.h"
#import "BlockAlertView.h"
static ResponseCodeCheck *responseCodeCheck = nil;

@implementation ResponseCodeCheck
@synthesize staticInfo;


- (id)init {

  self = [super init];
  if (self) {
    staticInfo = [StaticInfo getSinglton];
  }
  return self;
}

+ (ResponseCodeCheck *)getSinglton {

  @synchronized (self) {
    if (responseCodeCheck == nil) {
      responseCodeCheck = [[self alloc] init];
    }
  }
  return responseCodeCheck;
}


- (BOOL)checkConnect {

  NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
  if (networkStatus == NotReachable) {
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"网络连接失败" message:@"请检查网络，是否已连接网络?"];
    [alert setCancelButtonWithTitle:@"确定" block:^(void) {
      
    }];

    [alert show];

    staticInfo.canConnect = NO;
    return false;
  } else if (networkStatus == ReachableViaWWAN) {
    staticInfo.canConnect = YES;
    return true;
  } else {
    staticInfo.canConnect = YES;
    return true;
  }
}

- (BOOL)isWifi {

  NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
  if (networkStatus == ReachableViaWiFi) {
    return TRUE;
  }
  return FALSE;
}

- (BOOL)isWWAN {

  NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
  if (networkStatus == ReachableViaWWAN) {
    return TRUE;
  }
  return FALSE;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}
@end
