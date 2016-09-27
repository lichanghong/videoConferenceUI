//
//  LXConfItem.m
//  MoveProj
//
//  Created by lichanghong on 16/9/26.
//  Copyright © 2016年 lichanghong. All rights reserved.
//

#import "LXConfItem.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


@implementation LXConfItem


+ (LXConfItem *)createLXConfItem
{
    LXConfItem *item = [[LXConfItem alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    item.backgroundColor = RGB(arc4random()%255,arc4random()%255, arc4random()%255);
    item.hidden = YES;
    return item;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    for (CALayer *layer in self.layer.sublayers) {
        if (layer.backgroundColor == [UIColor grayColor].CGColor) {
            layer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
