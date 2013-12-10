//
//  TimelineCell.m
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-10.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
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
