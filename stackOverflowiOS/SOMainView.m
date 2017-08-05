//
//  SOMainView.m
//  stackOverflowiOS
//
//  Created by Ronald Kimutai on 04/08/2017.
//  Copyright © 2017 test ltd. All rights reserved.
//

#import "SOMainView.h"
#import "SOController.h"
#import "GlobalInstances.h"
#import "SOMainViewController.h"

@implementation SOMainView

-(void)loadScreen{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    float screenWidth = screenRect.size.width;
    float screenHeight = screenRect.size.height-[GlobalInstances getNavigationBarHeight]-[UIApplication sharedApplication].statusBarFrame.size.height;
    
    SOController *tempHandle = [GlobalInstances getNavigator];
    SOMainViewController *viewController = (SOMainViewController*) tempHandle.navigator.visibleViewController;
    
    self.backgroundColor = [UIColor whiteColor];
    
    //create UITableView
    UITableView *tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    tableView.tag = 1;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorColor = [UIColor grayColor];
    tableView.hidden = NO;
    tableView.scrollEnabled = YES;
    tableView.delegate = viewController;
    tableView.dataSource = viewController;
    [self addSubview:tableView];
    
    //create UIButton to retry when data is not loaded on the tableView
    UIButton *retryButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth - 100)/2, (screenHeight - 30)/2, 100, 30)];
    retryButton.backgroundColor = [UIColor clearColor];
    retryButton.tag = 2;
    retryButton.enabled = YES;
    retryButton.hidden = YES;
    [retryButton addTarget:viewController action:@selector(retryButtonListener:) forControlEvents:UIControlEventTouchUpInside];
    retryButton.titleLabel.font =  [UIFont systemFontOfSize:16];
    [retryButton setTitle:@"Tap to retry" forState:UIControlStateNormal];
    [retryButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    retryButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:retryButton];

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
