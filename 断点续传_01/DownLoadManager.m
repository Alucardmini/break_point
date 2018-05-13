//
//  DownLoadManager.m
//  断点续传_01
//
//  Created by 吴锡坤 on 5/12/18.
//  Copyright © 2018 吴锡坤. All rights reserved.
//

#import "DownLoadManager.h"

#import "NSString+Hash.h"

// 文件名（沙盒中的文件名），使用md5哈希url生成的，这样就能保证文件名唯一
#define  Filename  self.downLoadUrl.md5String
//存放路径
#define  FileStorePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: Filename]

// 文件的已被下载的大小
#define  DownloadLength [[[NSFileManager defaultManager] attributesOfItemAtPath: FileStorePath error:nil][NSFileSize] integerValue]

#define  TotalLengthPlist [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"totalLength.plist"]


@interface DownLoadManager ()<NSURLSessionDataDelegate>


/**
 下载任务
 */
@property (nonatomic, strong) NSURLSessionDataTask *task;

/**
 session
 */
@property (nonatomic, strong) NSURLSession *session;

/**
 写文件的流对象
 */
@property (nonatomic, strong) NSOutputStream *stream;

/**
 下载URL
 */
@property (nonatomic, strong) NSString *downLoadUrl;

/**
 文件总长度
 */
@property (nonatomic, assign) NSInteger totalLength;

@end

@implementation DownLoadManager

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone: zone];
    });
    
    return _instance;
}

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

#pragma mark -公开方法

- (void) downLoadWithURL:(NSString *)URL
                progress:(progressBlock)progressBlock
                 success:(successBlock)successsBLock
                  failed:(failedBlock)failedBlock{
    
    self.successBlock = successsBLock;
    self.progressBlock = progressBlock;
    self.failedBlock = failedBlock;
    self.downLoadUrl = URL;
    [self.task resume];
}

- (void)stopTask{
    [self.task suspend];
}

#pragma mark -getter方法
- (NSURLSession *)session{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

- (NSOutputStream *)stream{
    
    if (!_stream) {
        _stream = [NSOutputStream outputStreamToFileAtPath:FileStorePath append:YES];
    }
    return _stream;
}

- (NSURLSessionDataTask *)task{
    
    if (!_task) {
        
//        NSString* plistPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"totalLength.plist"];
        
        NSInteger totalLength = [[NSDictionary dictionaryWithContentsOfFile:TotalLengthPlist][Filename] integerValue];
        
        if (totalLength && DownloadLength == totalLength ) {
            NSLog(@"-*-*- 文件已下载过了");
            return nil;
        }
        
//        创建请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downLoadUrl]];
        //从已经下载的长度开始
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", DownloadLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        //创建一个DataTask
        _task = [self.session dataTaskWithRequest:request];
        
    }
    
    return _task;
}

#pragma mark -<NSURLSessionDataDelegate>

/**
 接收到回应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    //打开输出流
    [self.stream open];
    
    //allHeaderFields是NSHTTPURLResponse中的属性，NSHTTPURLResponse继承自NSURLResponse
    self.totalLength =  [((NSHTTPURLResponse *)response).allHeaderFields[@"Content-Length"] integerValue] + DownloadLength;
    
    //存入plist
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:TotalLengthPlist];
    
    if (nil == dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    NSString* fileName= Filename;
    
    dict[Filename] = @(self.totalLength);
    [dict writeToFile:TotalLengthPlist atomically:YES];
    completionHandler(NSURLSessionResponseAllow);
    
}

/**
 收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    //写入数据
    [self.stream write:data.bytes maxLength:data.length];
    
    //回调下载进度
    float progress =  1.0 * DownloadLength / self.totalLength;
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if (error) {
        if (self.failedBlock) {
            self.failedBlock(error);
        }
        self.stream = nil;
        //清除任务
        self.task = nil;
    }else{
        if (self.successBlock) {
            self.successBlock(FileStorePath);
        }
        
        [self.stream close];
        self.stream = nil;
        //清除任务
        self.task = nil;
    }

}


@end
