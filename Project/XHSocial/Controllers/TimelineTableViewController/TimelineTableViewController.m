//
//  TimelineTableViewController.m
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "TimelineTableViewController.h"

@interface TimelineTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *timeLines;
@end

@implementation TimelineTableViewController

#pragma mark - Propertys

- (NSArray *)timeLines {
    if (!_timeLines) {
        _timeLines = [[NSArray alloc] initWithObjects:@"曾宪华一号", @"曾宪华二号", @"曾宪华三号", @"曾宪华四号", @"曾宪华五号", @"曾宪华六号", nil];
    }
    return _timeLines;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = self.view.bounds;
        _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - Left cycle init

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#endif

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:213/255.0 blue:161/255.0 alpha:1]];
#endif
    self.title = NSLocalizedString(@"主页", @"");
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeLines.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *timeLineCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!timeLineCell) {
        timeLineCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    timeLineCell.textLabel.text = [self.timeLines objectAtIndex:indexPath.row];
    
    return timeLineCell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
