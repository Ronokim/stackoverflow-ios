//
//  SOQuestionsTableViewCell.h
//  stackOverflowiOS
//
//  Created by Ronald Kimutai on 04/08/2017.
//  Copyright © 2017 test ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOQuestionsTableViewCell : UITableViewCell

@property (retain,nonatomic) UILabel *titleLabel, *countLabel, *answerLabel, *dateLabel;
@property (retain,nonatomic)UICollectionView *tagsCollection;

@end
