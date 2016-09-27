//
//  LXConfView.h
//  MoveProj
//
//  Created by lichanghong on 16/9/26.
//  Copyright © 2016年 lichanghong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXConfItem;

@interface LXConfView : UIView

@property (nonatomic,strong)NSMutableArray *confVideos;


@property (nonatomic,strong)NSMutableArray *confItems;

@property (nonatomic,assign)BOOL shouldFullScreen; //default = yes

//default = NO ,fullscreen view can move to small view or not
@property (nonatomic,assign)BOOL shouldPanFullScreen;
@property (nonatomic,assign)BOOL shouldAlignCenter; //default NO;

+ (LXConfView *)createLXConfView;

- (void)show;

- (void)showWithFullScreen:(BOOL)fullScreen;

- (void)refreshLayout;

@end
