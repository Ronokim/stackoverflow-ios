//
//  SOMainViewController.h
//  stackOverflowiOS
//
//  Created by Ronald Kimutai on 04/08/2017.
//  Copyright © 2017 test ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOMainView.h"
#import "APIClient.h"

@interface SOMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,apiDelegate>{
    
}
@property(nonatomic, retain)SOMainView *viewObject;
@property(nonatomic, retain)UIActivityIndicatorView *activityIndicator;
@property(nonatomic, retain)APIClient *apiObject;

@end
