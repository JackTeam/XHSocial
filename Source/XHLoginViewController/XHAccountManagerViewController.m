//
//  XHAccountManagerViewController.m
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "XHAccountManagerViewController.h"

#define kXHTextFieldHeigth 35
#define kXHTextFieldPadding 2


@interface XHAccountManagerViewController ()
@property (nonatomic, strong) UIView *containerView;

// login
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

// reisted
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@end

@implementation XHAccountManagerViewController

- (void)completed:(User *)user {
    if (self.loginCompleted) {
        self.loginCompleted(user, self);
    }
}

- (void)login {
    [self completed:nil];
}

- (void)registed {
    [self completed:nil];
}

- (void)reseted {
    [self completed:nil];
}

#pragma mark - Propertys

- (XHAccountManagerViewController *)_initalizerAccountManagerViewControllerWithLoginType:(LoginType)loginType {
    XHAccountManagerViewController *accountManagerViewController = [[XHAccountManagerViewController alloc] init];
    accountManagerViewController.loginType = loginType;
    accountManagerViewController.loginCompleted = self.loginCompleted;
    return accountManagerViewController;
}

- (void)_initalizerTextFields {
    _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_containerView.frame), kXHTextFieldHeigth)];
    _emailTextField.backgroundColor = [UIColor whiteColor];
    _emailTextField.placeholder = NSLocalizedString(@"example@gmail.com", @"");
    [_emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_emailTextField.frame) + 2, CGRectGetWidth(_containerView.frame), kXHTextFieldHeigth)];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.placeholder = NSLocalizedString(@"密码", @"");
    _passwordTextField.secureTextEntry = YES;
    
    [_containerView addSubview:self.emailTextField];
    [_containerView addSubview:self.passwordTextField];
}

- (void)_initalizerResetPasswordButton {
    // 统一字体
	UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
	UIFont *defaultFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    
    UIButton *resetPasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [resetPasswordButton addTarget:self action:@selector(showResetPasswordViewController) forControlEvents:UIControlEventTouchUpInside];
    resetPasswordButton.frame = CGRectMake(10, CGRectGetHeight(_containerView.frame) + _containerView.frame.origin.y + 2, 300, 43);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor grayColor], defaultFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
	
	NSDictionary *attributesBold = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor blackColor], boldFont, nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    // 现在已有帐号?现在登录的英文版
    /*
     [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Already have an account? " attributes:attributes]];
     [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Sign in now" attributes:attributesBold]];
     */
    // 中文版
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"忘记了什么?" attributes:attributes]];
	[attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"重置你的密码" attributes:attributesBold]];
    
    [resetPasswordButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    [self.view addSubview:resetPasswordButton];
}

- (void)_initailizerContainerView:(CGRect)containerViewFrame {
    _containerView = [[UIView alloc] initWithFrame:containerViewFrame];
    _containerView.backgroundColor = [UIColor colorWithWhite:0.502 alpha:1.000];
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.cornerRadius = 6;
    [self.view addSubview:self.containerView];
}

#pragma mark - 重置相关的代码

- (void)_setupResetPasswordUI {
    // 一个提示label，一个输入框，输入邮箱，一个重置rightItem
    self.title = NSLocalizedString(@"重置", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"重置", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(reseted)];
    
    UILabel *resetPasswordWithEmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 300, 80)];
    resetPasswordWithEmailLabel.font = [UIFont systemFontOfSize:13.0f];
    resetPasswordWithEmailLabel.textAlignment = NSTextAlignmentCenter;
    resetPasswordWithEmailLabel.backgroundColor = [UIColor clearColor];
    resetPasswordWithEmailLabel.textColor = [UIColor whiteColor];
    resetPasswordWithEmailLabel.text = NSLocalizedString(@"请在下面输入你的邮件地址，我们会给你发送一个重置密码的链接", @"");
    resetPasswordWithEmailLabel.numberOfLines = 0;
    resetPasswordWithEmailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:resetPasswordWithEmailLabel];
    
    // 容器
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(mainBounds);
    CGFloat padding = 10;
    CGRect containerViewFrame = CGRectMake(padding, CGRectGetHeight(resetPasswordWithEmailLabel.frame) + resetPasswordWithEmailLabel.frame.origin.y, width - (padding * 2), kXHTextFieldHeigth);
    [self _initailizerContainerView:containerViewFrame];
    
    _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_containerView.frame), kXHTextFieldHeigth)];
    _emailTextField.backgroundColor = [UIColor whiteColor];
    _emailTextField.placeholder = NSLocalizedString(@"example@gmail.com", @"");
    [_emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.containerView addSubview:self.emailTextField];
}

#pragma mark - 注册相关的代码

- (void)_setupRegistedUI {
    // 两个文本输入框、一个提示按钮、一个RightItem 登录
    self.title = NSLocalizedString(@"注册", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(registed)];
    
    // 容器
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(mainBounds);
    CGFloat padding = 10;
    CGRect containerViewFrame = CGRectMake(padding, 80, width - (padding * 2), (kXHTextFieldHeigth * 3 + kXHTextFieldPadding * 2));
    [self _initailizerContainerView:containerViewFrame];
    
    [self _initalizerTextFields];
    
    _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_passwordTextField.frame) + _passwordTextField.frame.origin.y + 2, CGRectGetWidth(_passwordTextField.frame), kXHTextFieldHeigth)];
    _phoneNumberTextField.backgroundColor = [UIColor whiteColor];
    _phoneNumberTextField.placeholder = NSLocalizedString(@"15915895880", @"");
    [_phoneNumberTextField setKeyboardType:UIKeyboardTypeNamePhonePad];
    _phoneNumberTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_containerView addSubview:self.phoneNumberTextField];
}

#pragma mark - 登录相关的代码

- (void)showResetPasswordViewController {
    [self.navigationController pushViewController:[self _initalizerAccountManagerViewControllerWithLoginType:kResetPassword] animated:YES];
}

- (void)_setupLoginUI {
    // 两个文本输入框、一个提示按钮、一个RightItem 登录
    self.title = NSLocalizedString(@"登录", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"登录", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(login)];
    
    // 容器
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(mainBounds);
    CGFloat padding = 10;
    CGRect containerViewFrame = CGRectMake(padding, 100, width - (padding * 2), (kXHTextFieldHeigth * 2 + kXHTextFieldPadding));
    [self _initailizerContainerView:containerViewFrame];
    [self _initalizerTextFields];
    [self _initalizerResetPasswordButton];
}

#pragma mark - Left cycle init

- (void)_viewDidAppearHelp {
    switch (self.loginType) {
        case kSignin:
        case kEmailRegisted:
        case kResetPassword:
            [self.emailTextField becomeFirstResponder];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self _viewDidAppearHelp];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.413 green:0.339 blue:0.168 alpha:1.000];
    
    switch (self.loginType) {
        case kSignin:
            [self _setupLoginUI];
            break;
        case kResetPassword:
            [self _setupResetPasswordUI];
            break;
        case kEmailRegisted:
            [self _setupRegistedUI];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.containerView = nil;
    self.emailTextField = nil;
    self.passwordTextField = nil;
    self.phoneNumberTextField = nil;
}

@end
