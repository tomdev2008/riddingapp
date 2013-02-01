//
//  QQNRServerTaskQueue.h
//  Ridding
//
//  Created by zys on 12-12-22.
//
//

#import <Foundation/Foundation.h>
#import "QQNRServerTask.h"

@interface QQNRServerTaskQueue : NSObject <QQNRServerTaskQueueDelegate> {
  NSOperationQueue *_queue;
}

@property (nonatomic, retain) NSDictionary *lastTaskServerResponseJSON;

- (void)addTask:(QQNRServerTask *)task withDependency:(BOOL)dependsOnLastOperation;

+ (QQNRServerTaskQueue *)sharedQueue;

@end
