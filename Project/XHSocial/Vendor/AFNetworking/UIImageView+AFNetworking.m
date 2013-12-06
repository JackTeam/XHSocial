// UIImageView+AFNetworking.m
//
// Copyright (c) 2011 Gowalla (http://gowalla.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "AFImageCache.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import "UIImageView+AFNetworking.h"

#define TAG_PROGRESS_VIEW 149462

#define kImageFadeAnimationTime 0.7

#pragma mark -

static inline NSString * AFImageCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}

@interface ImageCache : NSCache
@property (nonatomic, strong) AFImageCache *afImageCache;
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
@end

static char kAFImageRequestOperationObjectKey;


@interface UIImageView (_AFNetworking)
@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFImageRequestOperation *af_imageRequestOperation;
@end

@implementation UIImageView (_AFNetworking)
@dynamic af_imageRequestOperation;
@end

#pragma mark -

@implementation UIImageView (AFNetworking)

- (AFHTTPRequestOperation *)af_imageRequestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, &kAFImageRequestOperationObjectKey);
}

- (void)af_setImageRequestOperation:(AFImageRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kAFImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_imageRequestOperationQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_af_imageRequestOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });

    return _af_imageRequestOperationQueue;
}

+ (NSMutableDictionary *)af_sharedProgressViewDictionary {
    static NSMutableDictionary *_af_progressViewDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_progressViewDictionary = [[NSMutableDictionary alloc] init];
    });
    
    return _af_progressViewDictionary;
}

+ (NSMutableDictionary *)af_sharedImageRequestDictionary {
    static NSMutableDictionary *_af_imageRequestDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_imageRequestDictionary = [[NSMutableDictionary alloc] init];
    });
    
    return _af_imageRequestDictionary;
}

+ (ImageCache *)af_sharedImageCache {
    static ImageCache *_af_imageCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _af_imageCache = [[ImageCache alloc] init];
    });

    return _af_imageCache;
}

#pragma mark -

- (void)addProgressView:(UIView *)progressView {
    UIView *existingProgressView = [self viewWithTag:TAG_PROGRESS_VIEW];
    if (!existingProgressView) {
        if (!progressView) {
            Class progressViewClass = [progressView class];
            id simpleProgerss = [[progressViewClass alloc] initWithFrame:self.bounds];
            progressView = simpleProgerss;
        }
        
        progressView.tag = TAG_PROGRESS_VIEW;
        
        // Move to the center
        float width = progressView.frame.size.width;
        float height = progressView.frame.size.height;
        float x = (self.frame.size.width / 2.0) - width/2;
        float y = (self.frame.size.height / 2.0) - height/2;
        progressView.frame = CGRectMake(x, y, width, height);
        
        [self addSubview:progressView];
    }
}

- (void)updateProgress:(CGFloat)progress progressKey:(NSString *)progressKey {
    UIView *progressView = [[[self class] af_sharedProgressViewDictionary] objectForKey:progressKey];
    if (progressView) {
        [progressView setValue:[NSNumber numberWithFloat:progress] forKey:@"progress"];
    }
}

- (void)removeProgressViewKey:(NSString *)progressKey {
    NSMutableDictionary *ProgressViewDictionary = [[self class] af_sharedProgressViewDictionary];
    UIView *progressView = [ProgressViewDictionary objectForKey:progressKey];
    if (progressView) {
        [progressView removeFromSuperview];
        [ProgressViewDictionary removeObjectForKey:progressKey];
    }
}


- (void)setImageWithURL:(NSURL *)url usingProgressView:(UIView *)progressView {
    [self setImageWithURL:url placeholderImage:nil usingProgressView:progressView];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
        usingProgressView:(UIView *)progressView
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];

    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil usingProgressView:progressView];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
      usingProgressView:(UIView *)progressView
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:success failure:nil usingProgressView:progressView];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
             usingProgressView:(UIView *)progressView
{
    [self cancelImageRequestOperation];
    if (placeholderImage) {
        self.image = placeholderImage;   
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        UIImage *cachedImage = [[[weakSelf class] af_sharedImageCache] cachedImageForRequest:urlRequest];
        if (cachedImage) {
            weakSelf.af_imageRequestOperation = nil;
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.image = cachedImage;
                    success(nil, nil, cachedImage);
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.image = cachedImage;
                });
                
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressView) {
                    UIView *dictionaryProgressView = [[[self class] af_sharedProgressViewDictionary] objectForKey:AFImageCacheKeyFromURLRequest(urlRequest)];
                    if (!dictionaryProgressView) {
                        [[[self class] af_sharedProgressViewDictionary] setObject:progressView forKey:AFImageCacheKeyFromURLRequest(urlRequest)];
                        [self addProgressView:progressView];
                    } else {
                        [self addProgressView:dictionaryProgressView];
                    }
                }
            });
    
            AFImageRequestOperation *requestOperation = [[[self class] af_sharedImageRequestDictionary] objectForKey:AFImageCacheKeyFromURLRequest(urlRequest)];
            if (!requestOperation) {
                requestOperation = [[AFImageRequestOperation alloc] initWithRequest:urlRequest];
                
                [[[self class] af_sharedImageRequestOperationQueue] addOperation:requestOperation];
                [[[self class] af_sharedImageRequestDictionary] setObject:requestOperation forKey:AFImageCacheKeyFromURLRequest(urlRequest)];
            }
            
            
            __weak typeof(requestOperation) weakRequestOperation = requestOperation;
            [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    __block long long BlockTotalBytesExpectedToRead = totalBytesExpectedToRead;
                    
                    NSHTTPURLResponse *response = (NSHTTPURLResponse*)weakRequestOperation.response;
                    NSString *contentLength = [[response allHeaderFields] objectForKey:@"Content-Length"];
                    if (contentLength != nil){
                        BlockTotalBytesExpectedToRead = [contentLength doubleValue];
                    }
                    
                    CGFloat downloadProgress =(float) totalBytesRead/BlockTotalBytesExpectedToRead;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf updateProgress:downloadProgress progressKey:AFImageCacheKeyFromURLRequest(urlRequest)];
                    });
                });
            }];
            
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf removeProgressViewKey:AFImageCacheKeyFromURLRequest(urlRequest)];
                        if (responseObject) {
                            [UIView transitionWithView:weakSelf duration:kImageFadeAnimationTime options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                weakSelf.image = responseObject;
                            } completion:nil];
                        }
                    });
                    self.af_imageRequestOperation = nil;
                }
                
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf removeProgressViewKey:AFImageCacheKeyFromURLRequest(urlRequest)];
                        
                        if (responseObject) {
                            [UIView transitionWithView:weakSelf duration:kImageFadeAnimationTime options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                weakSelf.image = responseObject;
                            } completion:nil];
                            
                            if (success) {
                                success(operation.request, operation.response, responseObject);
                            }
                        }
                        
                        
                    });
                }
                
                [[[self class] af_sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
                
                [[[self class] af_sharedImageRequestDictionary] removeObjectForKey:AFImageCacheKeyFromURLRequest(urlRequest)];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
                        self.af_imageRequestOperation = nil;
                    }
                    
                     [[[self class] af_sharedImageRequestDictionary] removeObjectForKey:AFImageCacheKeyFromURLRequest(urlRequest)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf removeProgressViewKey:AFImageCacheKeyFromURLRequest(urlRequest)];
                        weakSelf.image = [UIImage imageNamed:@"Failed.png"];
                        if (failure) {
                            failure(operation.request, operation.response, error);
                        }
                    });
                });
            }];
            self.af_imageRequestOperation = requestOperation;
        }
    });
    
}

- (void)cancelImageRequestOperation {
    if (self.af_imageRequestOperation) {
        [self.af_imageRequestOperation cancel];
        self.af_imageRequestOperation = nil;
    }
}

@end


@implementation ImageCache

- (id)init {
    self = [super init];
    if (self) {
        self.afImageCache = [self createCache];
    }
    return self;
}

- (AFImageCache *)createCache
{
    return [AFImageCache sharedImageCache];
}

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
    NSInteger cachePolicy = [request cachePolicy];
    switch (cachePolicy) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        case NSURLRequestReturnCacheDataElseLoad: {
            
        }
        default:
            break;
    }
    __block UIImage *cacheImage = nil;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_group_async(group, queue, ^{
        cacheImage = [self.afImageCache imageFromMemoryCacheForKey:AFImageCacheKeyFromURLRequest(request)];
        if (!cacheImage) {
            cacheImage = [self.afImageCache imageFromDiskCacheForKey:AFImageCacheKeyFromURLRequest(request)];
        }
        dispatch_semaphore_signal(semaphore);
    });
    
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    SDDispatchQueueRelease(group);
    SDDispatchQueueRelease(semaphore);
    
    return cacheImage;
}

- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request) {
        if ([request cachePolicy] == NSURLRequestReturnCacheDataElseLoad) {
            [self.afImageCache storeImage:image forKey:AFImageCacheKeyFromURLRequest(request)];
        }
    }
}

@end

#endif
