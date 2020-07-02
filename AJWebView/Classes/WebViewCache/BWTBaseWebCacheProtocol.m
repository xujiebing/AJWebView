//
//  BWTBaseWebCacheProtocol.m
//  BWTAbility
//
//  Created by ccc's MacBook Pro on 2017/12/27.
//

#import "BWTBaseWebCacheProtocol.h"

static NSString* const FilteredKey = @"FilteredKey";

@implementation BWTBaseWebCacheProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString* extension = request.URL.pathExtension;
    BOOL isMatch = [@[@"png", @"jpeg", @"gif", @"jpg", @"js", @"css", @"ttf"] indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [extension compare:obj options:NSCaseInsensitiveSearch] == NSOrderedSame;
    }] != NSNotFound;
    return [NSURLProtocol propertyForKey:FilteredKey inRequest:request] == nil && isMatch;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSMutableURLRequest* request = self.request.mutableCopy;
    [NSURLProtocol setProperty:@YES forKey:FilteredKey inRequest:request];
    
    // 在这里判断是否需要取缓存
    NSString *key = [NSString stringWithFormat:@"%@", request.URL];
    NSData *value = [BWTBaseWebCacheProtocol readDataWith:key.bwtBase64Encoding];
    if (!value) {
        // 从网络去取
        kRACWeakSelf
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            kRACStrongSelf
            if (error == nil) {
                [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
                [self.client URLProtocol:self didLoadData:data];
                [self.client URLProtocolDidFinishLoading:self];
                [BWTBaseWebCacheProtocol writeDataValueWithName:key.bwtBase64Encoding data:data];
            }
        }];
        [task resume];
        return;
    }
    
    // 从本地取
    NSData *data = value;
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading {
    
}

// 存webview的缓存文件
+ (BOOL)writeDataValueWithName:(NSString *)fileName data:(NSData *)data{
    NSString *path = [BWTBaseWebCacheProtocol finddocumentpath];//调用寻找Documents路径方法
    NSString *file = [NSString stringWithFormat:@"%@/%@", path, fileName];//在Documents/WKWebViewCache里建立一个文件
    BOOL result = [data writeToFile:file atomically:YES];//定义一个bool类型的变量，判断文件是否写入成功
    return result;
}

// 读取webview的缓存文件
+ (NSData *)readDataWith:(NSString *)fileName {
    NSString *path = [BWTBaseWebCacheProtocol finddocumentpath];
    NSString *readstring = [NSString stringWithFormat:@"%@/%@", path, fileName];//找到我们的file文件
    
    NSData *data = [[NSData alloc]initWithContentsOfFile:readstring];//取出文件里面的数据
    
    return data;
}

// 放置缓存文件的路径
+ (NSString *)finddocumentpath{
    //寻找documents路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *value = paths.lastObject;
    NSString *filePath = [NSString stringWithFormat:@"%@/BWTBaseWebCache", value];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"BWTBaseWebCache"];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
}

@end
