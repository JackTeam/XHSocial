//
//  XHLoginIconButton.m
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-6.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "XHLoginIconButton.h"
#import "User.h"

#define kImageMaxCube 40
#define kTitleRatio 0.2
#define kTopMarginRatio 0.2
#define kLeftMarginRatio 0.1

@implementation XHLoginIconButton

#pragma mark - Propertys

- (void)setLoginUser:(User *)loginUser {
    if (_loginUser == loginUser)
        return;
    
    _loginUser = loginUser;
    [self setTitle:loginUser.username forState:UIControlStateNormal];
}

#pragma mark - Left cycle init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setImage:[UIImage imageNamed:@"VineLogo.png"] forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - 覆盖父类的2个方法
#pragma mark 设置按钮标题的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat btnWidth = contentRect.size.width;
    if (btnWidth <= kImageMaxCube) return CGRectZero;
    
    CGFloat btnHeight = contentRect.size.height;
    CGFloat titleY = btnHeight * kTopMarginRatio + kImageMaxCube;
    CGFloat titleWidth = btnWidth;
    CGFloat titleHeight = contentRect.size.height * kTitleRatio;
    return CGRectMake(0, titleY, titleWidth,  titleHeight);
}

#pragma mark 设置按钮图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat btnWidth = contentRect.size.width;
    CGFloat imgY = contentRect.size.height * kTopMarginRatio;
    CGFloat imgX = 0;
    CGFloat imgWidth = 0;
    if (btnWidth > kImageMaxCube) {
        imgWidth = kImageMaxCube;
        imgX = (btnWidth - imgWidth) * 0.5;
        self.titleLabel.hidden = NO;
    } else {
        self.titleLabel.hidden = YES;
        imgX = btnWidth * kLeftMarginRatio;
        imgWidth = btnWidth - 2 * imgX;
    }
    CGFloat imgHeight = imgWidth;
    return CGRectMake(imgX, imgY, imgWidth, imgHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
