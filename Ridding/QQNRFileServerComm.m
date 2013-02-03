//
//  QQNRFilerServerComm.m
//  Ridding
//
//  Created by zys on 12-12-22.
//
//

#import "QQNRFileServerComm.h"
#import "NSDate+Addition.h"
#import "QiniuAuthPolicy.h"

static QQNRFileServerComm *qqnrFileServerComm = nil;

@implementation QQNRFileServerComm
+ (QQNRFileServerComm *)getSingleton {

  @synchronized (self) {
    if (qqnrFileServerComm == nil) {
      qqnrFileServerComm = [[self alloc] init];
    }
  }
  return qqnrFileServerComm;
}

- (void)updatePhotoToQiNiu:(RiddingPicture *)riddingPicture target:(id <QQNRFileClientServerUploadProtocol>)target {

  NSString *fileName = [self getFileName:riddingPicture.width height:riddingPicture.height];

  NSFileManager *manager = [NSFileManager defaultManager];
  if (riddingPicture.filePath == nil || ![manager fileExistsAtPath:riddingPicture.filePath]) {

    [target fileClientServerUploadOneFileError:nil];

    return;
  }

  int retureCode = [self doUpload:fileName localPath:riddingPicture.filePath];
  if (retureCode == 200) {
    fileName = [NSString stringWithFormat:@"/%@", fileName];
    riddingPicture.fileKey = fileName;
    // 成功
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, riddingPicture, kFileClientServerUpload_RiddingPicture);
    [target fileClientServerUploadOneFileSuccess:dic];

  } else {
    [target fileClientServerUploadOneFileError:nil];
  }
  if ([manager fileExistsAtPath:riddingPicture.filePath]) {
    [manager removeItemAtPath:riddingPicture.filePath error:nil];
  }
}

- (void)updateMapPhotoToQiNiu:(Ridding *)ridding target:(id <QQNRFileClientServerUploadProtocol>)target {

  NSString *fileName = [self getFileName:ridding.map.width height:ridding.map.height];

  NSString *localPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.jpg"];
  ridding.map.fileData = UIImageJPEGRepresentation(ridding.map.coverImage, 1.0);
  [ridding.map.fileData writeToFile:localPath atomically:YES];


  NSFileManager *manager = [NSFileManager defaultManager];
  if (localPath == nil || ![manager fileExistsAtPath:localPath]) {

    [target fileClientServerUploadOneFileError:nil];
    return;

  }

  int retureCode = [self doUpload:fileName localPath:localPath];

  if (retureCode == 200) {
    fileName = [NSString stringWithFormat:@"/%@", fileName];
    ridding.map.fileKey = fileName;
    // 成功
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, ridding, kFileClientServerUpload_Ridding);
    [target fileClientServerUploadOneFileSuccess:dic];

  } else {
    [target fileClientServerUploadOneFileError:nil];
  }
  if ([manager fileExistsAtPath:localPath]) {
    [manager removeItemAtPath:localPath error:nil];
  }

}


- (void)updateFileToQiNiu:(File *)file target:(id <QQNRFileClientServerUploadProtocol>)target {

  NSString *fileName = [self getFileName:file.width height:file.height];

  NSString *localPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.jpg"];
  file.fileData = UIImageJPEGRepresentation(file.fileImage, 1.0);
  [file.fileData writeToFile:localPath atomically:YES];


  NSFileManager *manager = [NSFileManager defaultManager];
  if (localPath == nil || ![manager fileExistsAtPath:localPath]) {

    [target fileClientServerUploadOneFileError:nil];
    return;

  }

  int retureCode = [self doUpload:fileName localPath:localPath];

  if (retureCode == 200) {
    fileName = [NSString stringWithFormat:@"/%@", fileName];
    file.fileKey = fileName;
    // 成功
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, file, kFileClientServerUpload_File);
    [target fileClientServerUploadOneFileSuccess:dic];

  } else {
    [target fileClientServerUploadOneFileError:nil];
  }
}


- (NSString *)tokenWithScope:(NSString *)scope {

  QiniuAuthPolicy *policy = [QiniuAuthPolicy new];
  policy.scope = scope;

  return [policy makeToken:@"8djjv3hXfS8eDOg9gR5UxxIpkmhfGg069FBv5c1e" secretKey:@"7oebuztbTfddVtI8dtY_QeftnWB09uZFPIQ8JuUm"];
}

- (int)doUpload:(NSString *)fileName localPath:(NSString *)localPath {

  NSFileManager *manager = [NSFileManager defaultManager];

  if (![manager fileExistsAtPath:localPath]) {

    return -1;

  }
  _uploader = [QiniuSimpleUploader uploaderWithToken:[self tokenWithScope:@"photo"]];
  return [_uploader upload:localPath bucket:@"photo" key:fileName extraParams:nil];
}

//得到上传到服务器的文件名
- (NSString *)getFileName:(int)width height:(int)height {

  NSString *timeDesc = [[NSDate date] pd_fileNameyyyyMMddHHmmss1String];
  NSString *randomKey = [NSString stringWithFormat:@"%d", arc4random() % 10000];
  return [NSString stringWithFormat:@"%@/%lld/%@_%@_%dx%d.jpg", @"photo", [StaticInfo getSinglton].user.userId, timeDesc, randomKey, width, height];
}


@end
