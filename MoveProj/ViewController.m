//
//  ViewController.m
//  MoveProj
//
//  Created by lichanghong on 16/9/26.
//  Copyright © 2016年 lichanghong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong)LXConfView *confV;

@property (nonatomic,strong)NSMutableArray *confVideos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _confV = [LXConfView createLXConfView];
    [_confV showWithFullScreen:YES];
    [_confV setShouldAlignCenter:YES];
    [self.view addSubview:_confV];
    [self.view bringSubviewToFront:self.addButton];
    [self.view bringSubviewToFront:self.removeButton];
    
    _confVideos = [NSMutableArray array];
    
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"img"];
    [_confVideos addObject:view];
    
    UIImageView *view1 = [[UIImageView alloc]init];
    view1.image = [UIImage imageNamed:@"img1"];
    [self.confVideos addObject:view1];
    
    
    UIImageView *view2 = [[UIImageView alloc]init];
    view2.image = [UIImage imageNamed:@"img2"];
    [self.confVideos addObject:view2];
    
    UIImageView *view3 = [[UIImageView alloc]init];
    view3.image = [UIImage imageNamed:@"img3"];
    [self.confVideos addObject:view3];
    UIImageView *view4 = [[UIImageView alloc]init];
    view4.image = [UIImage imageNamed:@"img4"];
    [self.confVideos addObject:view4];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)handleAction:(id)sender {
    if (_confV.confVideos.count<5 && sender == _addButton) {
        NSMutableArray *marr = [NSMutableArray array];

        for (NSObject *obj in self.confVideos) {
            if (![_confV.confVideos containsObject:obj]) {
                [marr addObject:obj];
            }
        }
        [_confV.confVideos addObject:[marr objectAtIndex:arc4random()%marr.count]];
        [_confV refreshLayout];
    }
    else if(sender == _removeButton)
    {
        if (_confV.confVideos.count>0) {
            [_confV.confVideos removeObject:[_confV.confVideos objectAtIndex:arc4random()%_confV.confVideos.count]];
            [_confV refreshLayout];
        }
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
