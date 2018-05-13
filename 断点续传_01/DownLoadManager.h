//
//  DownLoadManager.h
//  断点续传_01
//
//  Created by 吴锡坤 on 5/12/18.
//  Copyright © 2018 吴锡坤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock) (NSString *fileStorePath);
typedef void(^failedBlock) (NSError *error);
typedef void(^progressBlock) (float progress);

@interface DownLoadManager : NSObject

@property (copy) successBlock  successBlock;
@property (copy) failedBlock   failedBlock;
@property (copy) progressBlock progressBlock;

+ (instancetype)shareInstance;

- (void) downLoadWithURL:(NSString *)URL
                progress:(progressBlock)progressBlock
                 success:(successBlock)successsBLock
                  failed:(failedBlock)failedBlock;

- (void)stopTask;


@end
