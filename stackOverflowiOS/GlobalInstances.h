//
//  GlobalInstances.h
//  stackOverflowiOS
//
//  Created by Ronald Kimutai on 04/08/2017.
//  Copyright © 2017 test ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOController.h"

@interface GlobalInstances : NSObject

+(SOController*)getNavigator;
+(void)setNavigator:(SOController*)controllerInstance;

+(float)getNavigationBarHeight;
+(void)setNavigationBarHeight:(float)height;

+(float)getNavigationBarWidth;
+(void)setNavigationBarWidth:(float)width;

@end
