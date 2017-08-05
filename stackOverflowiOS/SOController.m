//
//  SOController.m
//  stackOverflowiOS
//
//  Created by Ronald Kimutai on 04/08/2017.
//  Copyright © 2017 test ltd. All rights reserved.
//

#import "SOController.h"

@implementation SOController{
    
}
@synthesize navigator,rootController;

-(id)init
{
    self = [super init];
    
    if(self)
    {
        [self setRootViewController];
    }
    return self;
}


-(UINavigationController*)getNavigationHandle
{
    if (nil != self->navigator)
        return self->navigator;
    
    return nil;
}


-(void)setRootViewController
{
    if (0 == navigator.viewControllers.count)
    {
        
        self.rootController = [[SOMainViewController alloc] init];
        self.navigator = [[UINavigationController alloc] initWithRootViewController:self.rootController];
    }
}


-(SOMainViewController*)getRootViewController
{
    if (0 != self->navigator.viewControllers.count)
    {
        if(nil != self->rootController)
            return self->rootController;
    }
    
    return nil;
}


@end
