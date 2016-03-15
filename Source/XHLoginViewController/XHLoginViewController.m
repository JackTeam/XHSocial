//
//  XHLoginViewController.m
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>

#import "XHAccountManagerViewController.h"

@interface XHLoginViewController ()
@property (nonatomic, strong) MPMoviePlayerController *player;
@end

@implementation XHLoginViewController

#pragma mark - Handle

- (void)showLoginController {
    switch (self.loginType) {
        case kSina:
            break;
        case kTencent:
            break;
        case kEmailRegisted:
            break;
        case kSignin:
            break;
        default:
            break;
    }
    XHAccountManagerViewController *accountManagerViewController = [[XHAccountManagerViewController alloc] init];
    accountManagerViewController.loginCompleted = self.loginCompleted;
    accountManagerViewController.loginType = self.loginType;
    [self.navigationController pushViewController:accountManagerViewController animated:YES];
    accountManagerViewController = nil;
}

- (void)loginHandle:(UIButton *)sender {
    LoginType selectLoginType = sender.tag;
    self.loginType = selectLoginType;
    [self showLoginController];
}

#pragma mark - Left cycle init

- (id)initWithLoginCompleted:(LoginCompleted)loginCompleted {
    self = [super init];
    if (self) {
        self.loginCompleted = loginCompleted;
    }
    return self;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
- (BOOL)prefersStatusBarHidden {
    return YES;
}
#endif

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self playVideo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.player pause];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
    CGRect screen = [[UIScreen mainScreen] bounds];
	
	NSURL *movieUrl = [[NSBundle mainBundle] URLForResource:@"background"  withExtension:@"mp4"];
	
    // 视频播放器
    _player = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    [_player setRepeatMode:MPMovieRepeatModeOne];
    _player.view.frame = screen;
	_player.scalingMode = MPMovieScalingModeFill;
	[self.player setControlStyle:MPMovieControlStyleNone];
	[self.view addSubview:self.player.view];
	[self.player prepareToPlay];
	
	// 自己的logo标志
	UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(90, 60, 150, 70)];
	logo.backgroundColor = [UIColor clearColor];
	[logo setImage:[UIImage imageNamed:@"VineLogo.png"]];
	[self.view addSubview:logo];
	
	// 统一字体
	UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
	UIFont *defaultFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
	
	
	NSDictionary * attributes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], defaultFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
	NSDictionary * attributesBold = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], boldFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
    // 利用新浪授权登录按钮
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaButton.tag = kSina;
    [sinaButton addTarget:self action:@selector(loginHandle:) forControlEvents:UIControlEventTouchUpInside];
    [sinaButton setFrame:CGRectMake(10, screen.size.height==568?340:250, 300, 43)];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    // 用 Sina 登录的英文版
    /*
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Sign in with " attributes:attributes]];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Sina" attributes:attributesBold]];
     */
    // 中文版
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"用 " attributes:attributes]];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Sina" attributes:attributesBold]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 登录" attributes:attributes]];
	[sinaButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [sinaButton setBackgroundImage:[UIImage imageNamed:@"signIn_twitter_button.png"] forState:UIControlStateNormal];
	[sinaButton setBackgroundImage:[UIImage imageNamed:@"signIn_twitter_button_tap.png"] forState:UIControlStateHighlighted];
	[sinaButton setBackgroundImage:[UIImage imageNamed:@"signIn_twitter_button_tap.png"] forState:UIControlStateSelected];
    [sinaButton setEnabled:YES];
    [self.view addSubview:sinaButton];
	
    // 利用腾讯授权登录按钮
	UIButton *tencentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tencentButton.tag = kTencent;
    [tencentButton addTarget:self action:@selector(loginHandle:) forControlEvents:UIControlEventTouchUpInside];
    [tencentButton setFrame:CGRectMake(10, screen.size.height==568?400:310, 300, 43)];
    attributedString = [[NSMutableAttributedString alloc] init];
    // 用腾讯登录的英文班
    /*
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Sign in with " attributes:attributes]];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Twitter" attributes:attributesBold]];
     */
    // 中文版
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"用 " attributes:attributes]];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Tencent" attributes:attributesBold]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 登录" attributes:attributes]];
	[tencentButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [tencentButton setBackgroundImage:[UIImage imageNamed:@"signIn_twitter_button.png"] forState:UIControlStateNormal];
	[tencentButton setBackgroundImage:[UIImage imageNamed:@"signIn_twitter_button_tap.png"] forState:UIControlStateHighlighted];
	[tencentButton setBackgroundImage:[UIImage imageNamed:@"signIn_twitter_button_tap.png"] forState:UIControlStateSelected];
    [tencentButton setEnabled:YES];
    [self.view addSubview:tencentButton];
	
	
	attributes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor blackColor], defaultFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
	attributesBold = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor blackColor], boldFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
    // 利用自己的Email授权登录按钮
	UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emailButton.tag = kUserNameSetter;
    [emailButton addTarget:self action:@selector(loginHandle:) forControlEvents:UIControlEventTouchUpInside];
    [emailButton setFrame:CGRectMake(10, screen.size.height==568?455:370, 300, 43)];
	
	attributedString = [[NSMutableAttributedString alloc] init];
    // 用 邮件地址 注册的英文版
    /*
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Sign up with " attributes:attributes]];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Email" attributes:attributesBold]];
     */
    // 中文版
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"用 " attributes:attributes]];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"邮件地址" attributes:attributesBold]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 注册" attributes:attributes]];
	[emailButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    [emailButton setBackgroundImage:[UIImage imageNamed:@"signIn_mail_button.png"] forState:UIControlStateNormal];
	[emailButton setBackgroundImage:[UIImage imageNamed:@"signIn_mail_buttonTap.png"] forState:UIControlStateHighlighted];
	[emailButton setBackgroundImage:[UIImage imageNamed:@"signIn_mail_buttonTap.png"] forState:UIControlStateSelected];
    [emailButton setEnabled:YES];
    [self.view addSubview:emailButton];
	
	
	boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
	defaultFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
	
	attributes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor grayColor], defaultFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
	attributesBold = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], boldFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
    // 提示用户进行注册的按钮
	UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signInButton.backgroundColor = [UIColor clearColor];
    signInButton.tag = kSignin;
    [signInButton addTarget:self action:@selector(loginHandle:) forControlEvents:UIControlEventTouchUpInside];
    [signInButton setFrame:CGRectMake(10, screen.size.height==568?500:410, 300, 43)];
    
	attributedString = [[NSMutableAttributedString alloc] init];
    
    // 现在已有帐号?现在登录的英文版
    /*
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Already have an account? " attributes:attributes]];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Sign in now" attributes:attributesBold]];
     */
    // 中文版
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"已有帐号? " attributes:attributes]];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"现在登录" attributes:attributesBold]];
	[signInButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [signInButton setEnabled:YES];
    [self.view addSubview:signInButton];
	
	// 注册通知
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playVideo)
												 name:MPMoviePlayerReadyForDisplayDidChangeNotification
											   object:self.player];
}

- (void)playVideo {
    if (!self.player)
        return;
    
	[self.player play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerReadyForDisplayDidChangeNotification object:self.player];
    self.player = nil;
}

@end
