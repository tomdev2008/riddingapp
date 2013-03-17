//
//  QQNRServerTask.m
//  Ridding
//
//  Created by zys on 12-12-22.
//
//

#import "QQNRServerTask.h"
#import "RiddingPictureDao.h"
#import "FDStatusBarNotifierView.h"
@implementation QQNRServerTask

- (void)taskMain {

  switch (self.step) {
    case STEP_UPLOADPHOTO: {
      [self performSelectorOnMainThread:@selector(updateUIWhenTaskBegin) withObject:nil waitUntilDone:NO];
      [[QQNRFileServerComm getSingleton] updatePhotoToQiNiu:[self.paramDic objectForKey:kFileClientServerUpload_RiddingPicture] target:self];
    }
      break;
    case STEP_UPLOADBACKGROUNDPHOTO: {
      [self performSelectorOnMainThread:@selector(updateUIWhenTaskBegin) withObject:nil waitUntilDone:NO];
      [[QQNRFileServerComm getSingleton] updateFileToQiNiu:[self.paramDic objectForKey:kFileClientServerUpload_File] target:self];
    }
      break;
    default:
      break;
  }
}

- (void)updateUIWhenTaskBegin {

  FDStatusBarNotifierView *barView=[[FDStatusBarNotifierView alloc]initWithMessage:@"照片上传中。"];
   RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  [barView showInWindow:delegate.window];

}

- (void)main {

 

  if ([self.dependencies count]>0 && self.queueDelegate) {
    NSDictionary *dic = [self.queueDelegate lastTaskServerResponseJSON];
    //如果post的param为空，尝试传非空的block
    if (dic!=nil) {
      if (_dataProcessBlock) {
       self.paramDic = _dataProcessBlock(dic);
      }
    }
  }
  [self taskMain];
}

#pragma mark - QQNRFileServerComm
- (void)fileClientServerUploadOneFileError:(NSDictionary *)info {

  if (self.taskDelegate) {
    [self.taskDelegate serverTask:self errorWithServerJSON:nil];
  }
  FDStatusBarNotifierView *barView=[[FDStatusBarNotifierView alloc]initWithMessage:@"上传失败"];
  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  barView.timeOnScreen=1.0;
  [barView showInWindow:delegate.window];
}

- (void)fileClientServerUploadOneFileSuccess:(NSDictionary *)info {

  if (self.taskDelegate) {
    [self.taskDelegate serverTask:self finishedWithServerJSON:info];
  }

  if (self.queueDelegate) {
    [self.queueDelegate setServerResponseJSON:info];
  }
  if(self.step==STEP_UPLOADPHOTO){
    
    RiddingPicture *riddingPicture = [info objectForKey:kFileClientServerUpload_RiddingPicture];
    RequestUtil *requestUtil = [[RequestUtil alloc] init];
    BOOL succ = [requestUtil uploadRiddingPhoto:riddingPicture];
    if (_dataProcessBlock) {
      _dataProcessBlock(info);
    }
    if (succ) {
      if(riddingPicture.dbId>0){
        
        [RiddingPictureDao deleteRiddingPicture:riddingPicture.dbId];
      }
      [[NSNotificationCenter defaultCenter] postNotificationName:kSuccUploadPictureNotification object:self];
    }
  }
  
  if (self.step == STEP_UPLOADBACKGROUNDPHOTO) {
    RequestUtil *request = [[RequestUtil alloc] init];
    File *file = [info objectForKey:kFileClientServerUpload_File];
    NSDictionary *dic = [request updateUserBackgroundUrl:file.fileKey];
    if (dic) {
      User *user = [[User alloc] initWithJSONDic:[dic objectForKey:keyUser]];
      [StaticInfo getSinglton].user.backGroundUrl = user.backGroundUrl;
      NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
      [prefs setObject:user.backGroundUrl forKey:kStaticInfo_backgroundUrl];
      [[NSNotificationCenter defaultCenter] postNotificationName:kSuccUploadBackgroundNotification object:self];
    }
  }

  [self performSelectorOnMainThread:@selector(updateStatusBarWithUploadPhotoStatus) withObject:nil waitUntilDone:NO];
}

- (void)updateStatusBarWithUploadPhotoStatus {

  FDStatusBarNotifierView *barView=[[FDStatusBarNotifierView alloc]initWithMessage:@"上传成功"];
  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  barView.timeOnScreen=1.0;
  [barView showInWindow:delegate.window];
  return;
}

@end
