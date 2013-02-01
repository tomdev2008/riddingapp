//
//  JsonCall.m
//  iEverBox
//
//  Created by tinyfool on 10-6-2.
//  Copyright 2010 SNDA. All rights reserved.
//

#import "JsonCall.h"
#import "JSONKit.h"

@implementation JsonCall
+ (NSURLRequest *)postRequestWithURL:(NSString *)url

                                data:(NSData *)data
                            fileName:(NSString *)fileName
                           otherInfo:(NSDictionary *)info {

  // from http://www.cocoadev.com/index.pl?HTTPFileUpload

  //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

  NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
  [urlRequest setURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
  urlRequest.timeoutInterval = 30.0;
  //[urlRequest setURL:url];

  [urlRequest setHTTPMethod:@"POST"];

  NSString *myboundary = @"---------------------------14737809831466499882746641449";
  NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", myboundary];
  [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
  //[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

  //[urlRequest addValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry] forHTTPHeaderField:@"Content-Type"];


  NSMutableData *postData = [NSMutableData data]; //[NSMutableData dataWithCapacity:[data length] + 512];
//    NSMutableString *string=[NSMutableString string];
//    [info enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        if (![key isEqualToString:@"data"]) {
//            [string appendFormat:@"%@=%@&",key,obj];
//        }
//        
//    }];
//    NSInteger len=[string length];
//    [string deleteCharactersInRange:NSMakeRange(len-1, 1)];
//    [postData appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
//    

  [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vid\"; \r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:[[info objectForKey:@"vid"] dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"; \r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:[[[info objectForKey:@"token"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];

  [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"myFiles\"; filename=\"%@\"  \r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:[NSData dataWithData:data]];
  [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];

  [urlRequest setHTTPBody:postData];
  return urlRequest;
}

+ (id)uploadWithURL:(NSString *)urlString withDict:(NSDictionary *)dict withData:(NSData *)data {

  NSURLRequest *theRequest = [self postRequestWithURL:urlString data:data fileName:@"xx.jpg" otherInfo:dict];

  NSHTTPURLResponse *response;
  NSData *retData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:nil];

  if (response.statusCode != 404) {
    DLog(@"%@ !404", urlString);
    return retData;
  }

  return nil;
}

+ (id)down:(NSString *)urlString withString:(NSString *)postString isForm:(BOOL)isForm {

  NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  DLog(@"JsonCall:%@", url);

  NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];

  theRequest.timeoutInterval = 30.0;
  theRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;

  [theRequest setValue:@"jfz_iOS_v2.0" forHTTPHeaderField:@"jfz_iOS_Device"];
  if (postString) {
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    if (isForm) {
      [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    [theRequest addValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];

    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:postData];
  } else {
    [theRequest setHTTPMethod:@"GET"];
  }

  NSHTTPURLResponse *response;
  NSData *retData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:nil];
  if (response.statusCode != 404) {
    DLog(@"%@  %d", urlString, response.statusCode);
    return retData;
  } else {
    DLog(@"%@ = %d", urlString, response.statusCode);
  }

  return nil;
}

+ (id)downloadImageWithURL:(NSString *)urlString withData:(id)data {

  NSData *retData = [self down:urlString withString:nil isForm:NO];
  if (retData) {
    return [UIImage imageWithData:retData];
  }
  return nil;
}

+ (id)call:(NSString *)urlString withData:(id)data {

  NSData *retData = [self down:urlString withString:data isForm:YES];

  if (!retData) {
    return nil;
  }

  //NSString* retString = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];

  id jsonValue = [retData objectFromJSONData];
  if (!jsonValue) {
    DLog(@"url:%@", urlString);
  }

  return jsonValue;
}

+ (id)uploadImageWithURL:(NSString *)urlString withDictinary:(NSDictionary *)dict {

  NSData *retData = [self uploadWithURL:urlString withDict:dict withData:[dict objectForKey:@"data"]];

  if (!retData) {
    return nil;
  }

  //NSString* retString = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];

  id jsonValue = [retData objectFromJSONData];
  if (!jsonValue) {
    DLog(@"url:%@", urlString);

  }
  DLog(@"value:%@", jsonValue);

  return jsonValue;
}
@end


