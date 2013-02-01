//
//  QQNRFilerServerComm.h
//  Ridding
//
//  Created by zys on 12-12-22.
//
//

#import <Foundation/Foundation.h>
#import "Ridding.h"
#import "QiniuSimpleUploader.h"
#pragma mark -
@protocol QQNRFileClientServerUploadProtocol <NSObject>

- (void)fileClientServerUploadOneFileError:(NSDictionary *)info;      // 单张照片或文件上传失败
- (void)fileClientServerUploadOneFileSuccess:(NSDictionary *)info;   // 单张照片或文件上传成功

@optional
- (void)fileClientServerUploadAllSuccess:(NSDictionary *)info;       // 全部上传成功

@end

@interface QQNRFileServerComm : NSObject {
  QiniuSimpleUploader *_uploader;
}


+ (QQNRFileServerComm *)getSingleton;

//单张图片上传处理机制
- (void)updatePhotoToQiNiu:(RiddingPicture *)riddingPicture target:(id <QQNRFileClientServerUploadProtocol>)target;

- (void)updateMapPhotoToQiNiu:(Ridding *)ridding target:(id <QQNRFileClientServerUploadProtocol>)target;

- (void)updateFileToQiNiu:(File *)file target:(id <QQNRFileClientServerUploadProtocol>)target;

@end
