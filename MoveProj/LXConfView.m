//
//  LXConfView.m
//  MoveProj
//
//  Created by lichanghong on 16/9/26.
//  Copyright © 2016年 lichanghong. All rights reserved.
//

#import "LXConfView.h"
#import "LXConfItem.h"

#define KScreenWidth            [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight           [[UIScreen mainScreen] bounds].size.height
#define KScreenRect             [[UIScreen mainScreen] bounds]
#define ViewW(v)                (v).frame.size.width
#define ViewH(v)                (v).frame.size.height
#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)
#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)
#define setY(v,y)   v.frame=CGRectMake(v.frame.origin.x, y , v.frame.size.width, v.frame.size.height)
#define setH(v,h)   v.frame=CGRectMake(v.frame.origin.x,v.frame.origin.y, v.frame.size.width, h)


@interface LXConfView ()<UIGestureRecognizerDelegate>

@end

@implementation LXConfView
{
    CGFloat marginT;
    CGFloat marginL;
    CGFloat margin ;
    CGFloat ratio  ; //w:h
    
    CGFloat width ;
    CGFloat height;

    CGFloat fullScreenCenterRadius;
}

+ (LXConfView *)createLXConfView{
    LXConfView *view = [[LXConfView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.confVideos = [NSMutableArray array];
    return view;
}

- (void)show
{
    [self calculateUI];
}

- (void)showWithFullScreen:(BOOL)fullScreen
{
    _shouldFullScreen = fullScreen;
    [self calculateUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _confItems = [NSMutableArray array];
        marginT = 50;
        marginL = 30;
        margin  = 20;
        ratio   = 1/1.5; //w:h
        fullScreenCenterRadius = 100;
        
        width = (KScreenWidth-(marginL*2)-margin*3)/4.0;
        height = width/ratio;
        _shouldFullScreen = YES;
        _shouldPanFullScreen = NO;
        _shouldAlignCenter = NO;
    }
    return self;
}

- (void)refreshLayout
{
    if (_confVideos.count>5) {
        return;
    }
    
    for (LXConfItem *item in _confItems) {
        item.hidden = YES;
    }
  
    for (int i=0; i<_confVideos.count; i++) {
        UIView *view = [_confVideos objectAtIndex:i];
        LXConfItem *item;
        if (i==0) {
            item = [_confItems firstObject];
            view.layer.frame = item.frame;
        }
        else {
            item = [_confItems objectAtIndex:i];
            view.layer.frame = CGRectMake(0, 0, item.frame.size.width, item.frame.size.height);
        }
        item.hidden = NO;
        view.layer.backgroundColor = [UIColor grayColor].CGColor;
        [item.layer insertSublayer:view.layer above:item.layer];

    }
    if (_shouldAlignCenter) {
        if (_confItems && _confVideos.count==2) {
           LXConfItem *conitem = [_confItems objectAtIndex:1];
            CGPoint center = self.center;
            conitem.frame = CGRectMake(center.x-width/2.0, marginT, width, height);
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.shouldAlignCenter = _shouldAlignCenter;
        }];
    }
}

- (void)calculateUI
{
    for (int i=1; i<=5; i++) {
        LXConfItem *item = [LXConfItem createLXConfItem];
        item.index = i-1;
        [_confItems addObject:item];
        [self addSubview:item];
        //add action
        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleActoin:)];
        [item addGestureRecognizer:panGestureRecognizer];
        if (!_shouldPanFullScreen) {
            panGestureRecognizer.delegate = self;
        }
        item.frame = CGRectMake(marginL+(margin+width)*(i-2), marginT, width, height);
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleActoin:)];
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        [tapGestureRecognizer setNumberOfTouchesRequired:1];
        [item addGestureRecognizer:tapGestureRecognizer];
    }
    LXConfItem *lastItem = [_confItems firstObject];
    if (_shouldFullScreen) {
        lastItem.frame = KScreenRect;
    }
    else
    {
        lastItem.frame = CGRectMake(marginL, height+marginT + 20, KScreenWidth - marginL*2, 350);
    }
}

- (void)setShouldAlignCenter:(BOOL)shouldAlignCenter
{
    _shouldAlignCenter = shouldAlignCenter;

    if (_confVideos.count<1 ) {
        return;
    }
    if (_confVideos.count==5) {
        [self reLayoutView];
        return;
    }
    if (_shouldAlignCenter) {
        LXConfItem *last = [_confItems objectAtIndex:_confVideos.count-1];
        CGPoint center = self.center;
        if (_confVideos.count==2) {
            last.frame = CGRectMake(center.x-width/2.0, marginT, width, height);
        }
        else if(_confVideos.count ==3)
        {
            LXConfItem *pre = [_confItems objectAtIndex:_confVideos.count-2];
            last.frame = CGRectMake(center.x+margin/2.0, marginT, width, height);
            pre.frame = CGRectMake(center.x-margin/2.0-width, marginT, width, height);
        }
        else if(_confVideos.count ==4)
        {
            LXConfItem *pre = [_confItems objectAtIndex:_confVideos.count-2];
            LXConfItem *fir = [_confItems objectAtIndex:_confVideos.count-3];
            pre.frame = CGRectMake(center.x-width/2.0, marginT, width, height);
            last.frame = CGRectMake(center.x+margin+width/2.0, marginT, width, height);
            fir.frame = CGRectMake(center.x-margin-width*1.5, marginT, width, height);
        }
        else
        {
        }
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (_shouldPanFullScreen) {
        return YES;
    }
    CGPoint point =[touch locationInView:self];
    LXConfItem *item = [_confItems lastObject];
    BOOL isLast = gestureRecognizer.view==[_confItems firstObject];
    if ((point.y > MaxY(item)+50 && isLast)|| !isLast) {
        return YES;
    }
    return NO;
}

- (void)handleActoin:(id)sender
{
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *paramSender = sender;
        LXConfItem *gestureV = (id)paramSender.view;
        
        static CGPoint lastFingerPoint;
        if (paramSender.state == UIGestureRecognizerStateBegan) {
            if (!_shouldFullScreen || gestureV.index!=0) {
                [self bringSubviewToFront: gestureV];
            }
        }
        else if(paramSender.state == UIGestureRecognizerStateChanged)
        {
            lastFingerPoint = [paramSender locationOfTouch:0 inView:self];
            CGPoint point = [paramSender translationInView:self];
            gestureV.center = CGPointMake(gestureV.center.x + point.x, gestureV.center.y + point.y);
            [paramSender setTranslation:CGPointMake(0, 0) inView:self];
        }
        else if (paramSender.state == UIGestureRecognizerStateEnded)
        {
            for (LXConfItem *item in _confItems) {
                if (item==gestureV || item.isHidden) {
                    continue;
                }

                if (gestureV == [_confItems firstObject] && item.isHidden==NO) {
                    __block CGPoint gestureC = lastFingerPoint;
                    CGFloat vix = item.frame.origin.x;
                    CGFloat viy = item.frame.origin.y;
                    CGFloat vimx = CGRectGetMaxX(item.frame);
                    CGFloat vimy = CGRectGetMaxY(item.frame);
                    if (gestureC.x>vix  && gestureC.x<vimx && gestureC.y>viy && gestureC.y<vimy) {
                        [_confItems exchangeObjectAtIndex:item.index withObjectAtIndex:gestureV.index];
                        int index =0;
                        index = item.index;
                        item.index = gestureV.index;
                        gestureV.index = index;
                        [UIView animateWithDuration:0.3
                                              delay:0
                             usingSpringWithDamping:0.7
                              initialSpringVelocity:0.8
                                            options:UIViewAnimationOptionCurveEaseIn
                                         animations:^{
                                             item.frame = CGRectMake(marginL+(margin+width)*(gestureV.index-1), marginT, width, height);
                                             gestureV.frame = CGRectMake(marginL+(margin+width)*(item.index-1), marginT, width, height);
                                             self.shouldAlignCenter = _shouldAlignCenter;
                                         } completion:^(BOOL finished) {
                                             gestureC = CGPointZero;
                                         }];
                        break;
                    }
                     gestureC = CGPointZero;
                }
                else  if ([self isView:gestureV Contains:item]) {
                    [_confItems exchangeObjectAtIndex:item.index withObjectAtIndex:gestureV.index];
                    int index =0;
                    index = item.index;
                    item.index = gestureV.index;
                    gestureV.index = index;
                    CGRect itemF = item.frame;
                    [UIView animateWithDuration:0.3
                                          delay:0
                         usingSpringWithDamping:0.7
                          initialSpringVelocity:0.8
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         item.frame = gestureV.frame;
                                         gestureV.frame = itemF;
                                     } completion:^(BOOL finished) {
                                     }];
                    break;
                }
            }
            [self reLayoutView];
            self.shouldAlignCenter = _shouldAlignCenter;
        }
        else
        {
            CGPoint point = [paramSender translationInView:self];
            gestureV.center = CGPointMake(gestureV.center.x + point.x, gestureV.center.y + point.y);
            [paramSender setTranslation:CGPointMake(0, 0) inView:self];
        }
        
    }
    else if([sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        UITapGestureRecognizer *paramSender = sender;
        LXConfItem *gestureV = (id)paramSender.view;
        LXConfItem *lastV    = [_confItems firstObject];
        if (gestureV != lastV) {
            [_confItems exchangeObjectAtIndex:gestureV.index withObjectAtIndex:lastV.index];
            int index =0;
            index = lastV.index;
            lastV.index = gestureV.index;
            gestureV.index = index;
            [UIView animateWithDuration:0.3
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.8
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 [self reLayoutView];
                                 self.shouldAlignCenter = _shouldAlignCenter;
                             } completion:^(BOOL finished) {
                             }];
        }
    }
}

- (void)reLayoutView
{
    for (int i=0; i<5; i++) {
        LXConfItem *item = [_confItems objectAtIndex:i];
        if (i!=0) {
            [self bringSubviewToFront:item];
        }
        item.frame = CGRectMake(marginL+(margin+width)*(i-1), marginT, width, height);
    }
    LXConfItem *lastItem = [_confItems firstObject];
    if (_shouldFullScreen) {
        lastItem.frame = KScreenRect;
    }
    else
    {
        lastItem.frame = CGRectMake(marginL, height+marginT + 20, KScreenWidth - marginL*2, 350);
    }
}

- (BOOL)isView:(LXConfItem *)view1 Contains:(LXConfItem *)view2
{
    if (view2.isHidden || view1.isHidden) {
        return NO;
    }
    CGPoint view1center = view1.center;
    CGFloat vix = view2.frame.origin.x;
    CGFloat viy = view2.frame.origin.y;
    CGFloat vimx = CGRectGetMaxX(view2.frame);
    CGFloat vimy = CGRectGetMaxY(view2.frame);
//    NSLog(@"%@  %@",NSStringFromCGPoint(view1center),NSStringFromCGRect(view2.frame));
    if (_shouldFullScreen) {
        LXConfItem *last=[_confItems firstObject];
        
        CGPoint center = view1center;
        if (last==view1 || last == view2) {
            if (last==view1) {
                center = view2.center;
            }
            vix = last.center.x-fullScreenCenterRadius;
            viy = last.center.y-fullScreenCenterRadius;
            vimx = last.center.x+fullScreenCenterRadius;
            vimy = last.center.y+fullScreenCenterRadius;

        }
        
        if (center.x>vix  && center.x<vimx && center.y>viy && center.y<vimy) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    if (view1center.x>vix  && view1center.x<vimx && view1center.y>viy && view1center.y<vimy) {
        return YES;
    }
    return NO;
}












@end
