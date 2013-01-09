//
//  QiniuSimpleUploader.m
//  QiniuSimpleUploader
//
//  Created by Qiniu Developers on 12-11-14.
//  Copyright (c) 2012 Shanghai Qiniu Information Technologies Co., Ltd. All rights reserved.
//

#import "QiniuConfig.h"
#import "QiniuSimpleUploader.h"
#import "ASIFormDataRequest.h"
#import "GTMBase64.h"
#import "JSONKit.h"

#define kErrorDomain @"QiniuSimpleUploader"
#define kFilePathKey @"filePath"
#define kHashKey @"hash"
#define kErrorKey @"error"
#define kFileSizeKey @"fileSize"
#define kKeyKey @"key"
#define kBucketKey @"bucket"
#define kExtraParamsKey @"extraParams"

NSString *urlsafeBase64String(NSString *sourceString)
{
    return [GTMBase64 stringByWebSafeEncodingData:[sourceString dataUsingEncoding:NSUTF8StringEncoding] padded:TRUE];
}

// Convert NSDictionary to strings like: key1=value1&key2=value2&key3=value3 ...
NSString *urlParamsString(NSDictionary *dic)
{
    if (!dic) {
        return nil;
    }
    
    NSMutableString *callbackParamsStr = [NSMutableString string];
    for (NSString *key in [dic allKeys]) {
        if ([callbackParamsStr length] > 0) {
            [callbackParamsStr appendString:@"&"];
        }
        [callbackParamsStr appendFormat:@"%@=%@", key, [dic objectForKey:key]];
    }
    return callbackParamsStr;
}

// ------------------------------------------------------------------------------------------

@implementation QiniuSimpleUploader

@synthesize delegate;

+ (id) uploaderWithToken:(NSString *)token
{
    return [[[self alloc] initWithToken:token] autorelease];
}

// Must always override super's designated initializer.
- (id)init {
    return [self initWithToken:nil];
}

- (id)initWithToken:(NSString *)token
{
    if (self = [super init]) {
        _token = [token copy];
        _request = nil;
    }
    return self;
}

- (void) dealloc
{
    [_token autorelease];
    if (_request) {
        [_request clearDelegatesAndCancel];
        [_request release];
    }
    [super dealloc];
}

- (void)setToken:(NSString *)token
{
    [_token autorelease];
    _token = [token copy];
}

- (id)token
{
    return _token;
}

- (int) upload:(NSString *)filePath
         bucket:(NSString *)bucket
            key:(NSString *)key
    extraParams:(NSDictionary *)extraParams
{
  // If upload is called multiple times, we should cancel previous procedure.
  if (_request) {
    [_request clearDelegatesAndCancel];
    [_request release];
  }
  
  NSString *url = [NSString stringWithFormat:@"%@/upload", kUpHost];
  
  NSString *mimeType = @"application/octet-stream";
  if (extraParams) {
    NSObject *mimeTypeObj = [extraParams objectForKey:kMimeTypeKey];
    if (mimeTypeObj) {
      mimeType = (NSString *)mimeTypeObj;
    }
  }
  
  NSString *encodedMimeType = urlsafeBase64String(mimeType);
  NSString *encodedEntry = urlsafeBase64String([NSString stringWithFormat:@"%@:%@", bucket, key]);
  
  // Prepare POST body fields.
  NSMutableString *action = [NSMutableString stringWithFormat:@"/rs-put/%@/mimeType/%@", encodedEntry, encodedMimeType];
  
  if (extraParams) {
    NSObject *customMetaObj = [extraParams objectForKey:kCustomMetaKey];
    if (customMetaObj) {
      NSString *customMeta = (NSString *)customMetaObj;
      NSString *encodedCustomMeta = urlsafeBase64String(customMeta);
      
      [action appendFormat:@"/meta/%@", encodedCustomMeta];
    }
  }
  
  _request = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]] retain];
  _request.delegate = self;
  _request.uploadProgressDelegate = self;
  
  [_request addPostValue:action forKey:@"action"];
  [_request addFile:filePath forKey:@"file"];
  
  if (_token) {
    [_request addPostValue:_token forKey:@"auth"];
  }
  
  if (extraParams) {
    NSObject *callbackParamsObj = [extraParams objectForKey:kCallbackParamsKey];
    if (callbackParamsObj != nil) {
      NSDictionary *callbackParams = (NSDictionary *)callbackParamsObj;
      
      [_request addPostValue:urlParamsString(callbackParams) forKey:@"params"];
    }
  }
  
  NSNumber* fileSizeNumber = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] objectForKey:NSFileSize];
  
  NSDictionary *context = [NSDictionary dictionaryWithObjectsAndKeys:filePath, kFilePathKey,
                           fileSizeNumber, kFileSizeKey,
                           bucket, kBucketKey,
                           key, kKeyKey,
                           extraParams, kExtraParamsKey, // Might be nil.
                           nil];
  
  [_request setUserInfo:context];
  
  [_request startSynchronous];  //同步操作完成后
  
  //NSDictionary *dic = nil;
//  NSError *httpError = nil;
//  if (_request) {
//    NSString *responseString = [_request responseString];
//    if (responseString) {
//      dic = [responseString objectFromJSONString];
//    }
//    NSObject *context = [_request userInfo];
//    if (context) {
//      NSDictionary *contextDic = (NSDictionary *)context;
//      filePath = (NSString *)[contextDic objectForKey:kFilePathKey];
//    }
    
//    httpError = [_request error];
//  }
  
  return [_request responseStatusCode];
//  if (statusCode / 100 == 2) {
//    return statusCode;
//  }
//  
//  int errorCode = 400;
//  NSString *errorDescription = nil;
//  if (dic) { // Check if there is response content.
//    NSObject *errorObj = [dic objectForKey:kErrorKey];
//    if (errorObj) {
//      errorDescription = [(NSString *)errorObj copy];
//    }
//  }
//  if (errorDescription == nil && httpError) { // No response, then try to retrieve the HTTP error info.
//    errorCode = [httpError code];
//    errorDescription = [httpError localizedDescription];
//  }
//  
//  NSDictionary *userInfo = nil;
//  if (errorDescription) {
//    userInfo = [NSDictionary dictionaryWithObject:errorDescription forKey:kErrorKey];
//  }
//  NSError *error = [NSError errorWithDomain:kErrorDomain code:errorCode userInfo:userInfo];
//  return error.code;
}

@end
