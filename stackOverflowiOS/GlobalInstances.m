//
//  GlobalInstances.m
//  stackOverflowiOS
//
//  Created by Ronald Kimutai on 04/08/2017.
//  Copyright © 2017 test ltd. All rights reserved.
//

#import "GlobalInstances.h"

SOController *navigationInstance;
UINavigationController *mainInstance;
float navHeight,navWidth;

@implementation GlobalInstances

+(SOController*)getNavigator
{
    if(nil == navigationInstance)
        return nil;
    
    return navigationInstance;
}

+(void)setNavigator:(SOController*)controllerInstance
{
    navigationInstance=controllerInstance;
}

+(float)getNavigationBarHeight
{
    return navHeight;
}

+(void)setNavigationBarHeight:(float)height
{
    navHeight = height;
}

+(float)getNavigationBarWidth
{
    return navWidth;
}

+(void)setNavigationBarWidth:(float)width;
{
    navWidth = width;
}


@end
