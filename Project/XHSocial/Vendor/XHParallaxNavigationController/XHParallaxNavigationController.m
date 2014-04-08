//
//  XHParallaxNavigationController.m
//  iyilunba
//
//  Created by 曾 宪华 on 13-12-4.
//  Copyright (c) 2013年 曾 宪华 开发团队(http://iyilunba.com ). All rights reserved.
//

#import "XHParallaxNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import <Accelerate/Accelerate.h>

#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]
#define kBackViewHeight [UIScreen mainScreen].bounds.size.height
#define kBackViewWidth [UIScreen mainScreen].bounds.size.width

@interface XHParallaxNavigationController () {
    CGFloat startBackViewX;
    
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
    
    // 模糊图片的图片
    UIImage *captureImg;
}

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *screenShotsList;

@property (nonatomic, assign) BOOL isMoving;

@property (nonatomic, assign) BOOL isTouchBegin;

@end

@implementation XHParallaxNavigationController

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
// This code will only compile on versions >= iOS 7.0
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.hideStatusBar;
}
#endif

- (id)init {
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
    self.canDragBack = YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)dealloc
{
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    
    self.view.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.view.layer.shadowOffset = CGSizeMake(5, 5);
    self.view.layer.shadowRadius = 5;
    self.view.layer.shadowOpacity = 1;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.screenShotsList addObject:[self capture]];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    
    return [super popViewControllerAnimated:animated];
}


#pragma mark - Utility Methods -

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)moveViewWithX:(float)x
{
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    x = x > width ? width : x;
    x = x < 0 ? 0 : x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float alpha = 0.5 - (x / (width * 2));
    
    blackMask.alpha = alpha;
    
    // GCD Lai做处理
    
    if (self.isBlurry) {
        if (alpha>0.02f) {
            // 0.000000  0.152500
            NSString *old = [NSString stringWithFormat:@"%f",alpha];
            NSString *oldtmp = [old substringToIndex:4];
            CGFloat toValueTmp = [oldtmp floatValue];
            
            
            NSRange rangeTmp = NSMakeRange(2, 2);
            NSString *tmpRange = [old substringWithRange:rangeTmp];
            
            if ([tmpRange intValue]%3==0)
            {
                [self goToBlurry:toValueTmp];
                
            }
            NSLog(@"intValue : %d", [tmpRange intValue]);
            switch ([tmpRange intValue]) {
                case 38:
                case 33:
                case 28:
                case 23:
                case 18:
                case 13:
                case 8:
                case 3: {
                    [self goToBlurry:toValueTmp];
                    break;
                }
                default:
                    break;
            }
            
        }
    }
    
    CGFloat aa = abs(startBackViewX)/kBackViewWidth;
    CGFloat y = x*aa;
    
    CGFloat lastScreenShotViewHeight = kBackViewHeight;
    
    [lastScreenShotView setFrame:CGRectMake(startBackViewX+y,
                                            0,
                                            kBackViewWidth,
                                            lastScreenShotViewHeight)];
    
}

// 通过GCD来处理图片.

-(void)goToBlurry:(CGFloat )valueTmp
{
    UIImage *tmp =[self.screenShotsList lastObject];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurredImage = [self blurryImage:tmp withBlurLevel: valueTmp];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            lastScreenShotView.image = blurredImage;
        });
    });
}

#pragma mark - 进行模糊图片

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        self.isTouchBegin = YES;
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        
        startBackViewX = startX;
        [lastScreenShotView setFrame:CGRectMake(startBackViewX,
                                                lastScreenShotView.frame.origin.y,
                                                lastScreenShotView.frame.size.height,
                                                lastScreenShotView.frame.size.width)];
        
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        self.isTouchBegin = NO;
        if (self.parallaxNavigationControllerMovieEnd) {
            self.parallaxNavigationControllerMovieEnd(self);
        }
        if (touchPoint.x - startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:CGRectGetWidth([[UIScreen mainScreen] bounds])];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
    } else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        self.isTouchBegin = NO;
        if (self.parallaxNavigationControllerMovieCancel) {
            self.parallaxNavigationControllerMovieCancel(self);
        }
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    if (_isMoving) {
        CGFloat distans = touchPoint.x - startTouch.x;
        [self moveViewWithX:distans];
        if (distans > 0) {
            if (!self.isTouchBegin)
                return;
            if (self.parallaxNavigationControllerMovieBegin) {
                self.parallaxNavigationControllerMovieBegin(self);
            }
            self.isTouchBegin = NO;
        }
    }
}

@end

@implementation UIViewController (XHParallaxNavigationController)

- (void)addParallaxNavigationControllerMovieBegin:(ParallaxNavigationControllerMovieBegin)parallaxNavigationControllerMovieBegin {
    self.xh_parallaxNavigationController.parallaxNavigationControllerMovieBegin = parallaxNavigationControllerMovieBegin;
}

- (void)addParallaxNavigationControllerMovieEnd:(ParallaxNavigationControllerMovieEnd)parallaxNavigationControllerMovieEnd {
    self.xh_parallaxNavigationController.parallaxNavigationControllerMovieEnd = parallaxNavigationControllerMovieEnd;
}

- (void)addParallaxNavigationControllerMovieCancel:(ParallaxNavigationControllerMovieCancel)parallaxNavigationControllerMovieCancel {
    self.xh_parallaxNavigationController.parallaxNavigationControllerMovieCancel = parallaxNavigationControllerMovieCancel;
}

- (XHParallaxNavigationController *)xh_parallaxNavigationController {
    XHParallaxNavigationController *navigationController = nil;
    if ([self.navigationController isKindOfClass:[XHParallaxNavigationController class]])
        navigationController = (XHParallaxNavigationController *)self.navigationController;
    return navigationController;
}

@end

