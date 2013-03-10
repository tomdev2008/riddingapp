//
//  QQNRServerTask.h
//  Ridding
//
//  Created by zys on 12-12-22.
//
//

#import <Foundation/Foundation.h>
#import "QQNRFileServerComm.h"

@class QQNRServerTask;

typedef NSMutableDictionary *(^BlockProcessLastTaskData)(NSDictionary *);

typedef enum TASKSTEP_ {
  STEP_UPLOADPHOTO,
  STEP_UPLOADBACKGROUNDPHOTO,
} TASKSTEP;


@protocol QQNRServerTaskDelegate <NSObject>

- (void)serverTask:(QQNRServerTask *)task finishedWithServerJSON:(NSDictionary *)jsonData;

- (void)serverTask:(QQNRServerTask *)task errorWithServerJSON:(NSDictionary *)jsonData;

@end

@protocol QQNRServerTaskQueueDelegate <NSObject>

- (void)setServerResponseJSON:(NSDictionary *)serverJSON;

- (NSInteger)countOfTasksRemainsInQueue;

- (NSDictionary *)lastTaskServerResponseJSON;

@optional
- (NSUInteger)totalPhotoCountsInQueue;        /// 队列里面还有多少照片
- (NSUInteger)finishedCountsInQueue;          /// 队列里面单个任务当前完成了多少照片

@end

@interface QQNRServerTask : NSOperation <QQNRFileClientServerUploadProtocol>

@property (nonatomic, copy) NSString *taskBeginMessage;
@property (nonatomic, copy) NSString *taskFinishMessage;
@property (nonatomic, retain) NSMutableDictionary *paramDic;
@property (nonatomic) TASKSTEP step;

@property (nonatomic, assign) id <QQNRServerTaskQueueDelegate> queueDelegate;
@property (nonatomic, assign) id <QQNRServerTaskDelegate> taskDelegate;

@property (nonatomic, copy) BlockProcessLastTaskData dataProcessBlock;

@end
