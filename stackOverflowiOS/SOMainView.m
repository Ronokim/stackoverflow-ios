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
    
    UITableView *tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    tableView.tag = 1;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorColor = [UIColor grayColor];
    tableView.hidden = NO;
    tableView.scrollEnabled = YES;
    tableView.delegate = viewController;
    tableView.dataSource = viewController;
    [self addSubview:tableView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
