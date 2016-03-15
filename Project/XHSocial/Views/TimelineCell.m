//
//  TimelineCell.m
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-10.
//  Copyright (c) 2013年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "TimelineCell.h"
#import "User.h"

@interface TimelineCell ()


@end

@implementation TimelineCell

- (void)setUser:(User *)user {
    _user = user;
    self.textLabel.text = user.username;
    self.detailTextLabel.text = user.constellation;
    self.imageView.image = [UIImage imageNamed:@"VineLogo"];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
