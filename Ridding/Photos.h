//
//  Photos.h
//  Sample
//
//  Created by Kirby Turner on 2/10/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTPhotoBrowserDataSource.h"

@protocol PhotosDelegate;

@interface Photos : NSObject <KTPhotoBrowserDataSource> {
   id<PhotosDelegate> delegate_;
   
   NSString *documentPath_;
   NSString *photosPath_;
   NSString *thumbnailsPath_;
   
   NSMutableArray *fileNames_;
   NSMutableDictionary *photoCache_;
   NSMutableDictionary *thumbnailCache_;
   
   NSOperationQueue *queue_;
}

@property (nonatomic, assign) id<PhotosDelegate> delegate;
@property (nonatomic) long long riddingId;

- (void)flushCache;
- (void)savePhoto:(UIImage *)photo withName:(NSString *)name addToPhotoAlbum:(BOOL)addToPhotoAlbum;
- (UIImage*)getPhoto:(NSString*)name;
- (NSString*)getPhotoPath:(NSString*)name;
- (NSString*)getFileName:(long long)aRiddingId userId:(long long)userId dateStr:(NSString*)dateStr;
@end


@protocol PhotosDelegate <NSObject>
@optional
- (void)didFinishSave;
- (void)deleteImageAtName:(NSString*)name;

@end