//
//  SOController.h
//  stackOverflowiOS
//
//  Created by Ronald Kimutai on 04/08/2017.
//  Copyright © 2017 test ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOMainViewController.h"

@interface SOController : NSObject

@property (nonatomic,retain)UINavigationController *navigator;
@property (nonatomic, strong)SOMainViewController *rootController;

-(UINavigationController*)getNavigationHandle;

@end
