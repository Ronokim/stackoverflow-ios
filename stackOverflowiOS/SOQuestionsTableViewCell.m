//
//  SOQuestionsTableViewCell.m
//  stackOverflowiOS
//
//  Created by Ronald Kimutai on 04/08/2017.
//  Copyright © 2017 test ltd. All rights reserved.
//

#import "SOQuestionsTableViewCell.h"
#import "SOController.h"
#import "GlobalInstances.h"
#import "UIColor+CustomColors.h"

@implementation SOQuestionsTableViewCell
@synthesize titleLabel,countLabel,answerLabel,dateLabel,tagsCollection;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        countLabel.backgroundColor = [UIColor customLightGray];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.textColor = [UIColor blackColor];
        countLabel.layer.cornerRadius=25;
        countLabel.layer.masksToBounds = YES;
        countLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:countLabel];
        
        
        answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75 , 50, 20)];
        answerLabel.backgroundColor = [UIColor clearColor];
        answerLabel.text = @"Answer";
        answerLabel.textAlignment = NSTextAlignmentCenter;
        answerLabel.textColor = [UIColor blackColor];
        answerLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:answerLabel];
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(countLabel.frame.size.width + countLabel.frame.origin.x + 5, 10, self.frame.size.width -75, 50)];
        titleLabel.tag = 1;
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.clipsToBounds =YES;
        [self addSubview:titleLabel];
        
        
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.7, 75 , self.frame.size.width*0.28, 20)];
        dateLabel.numberOfLines = 0;
        dateLabel.tag = 3;
        dateLabel.font = [UIFont systemFontOfSize:11];
        dateLabel.textAlignment = NSTextAlignmentRight;
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        //[dateLabel sizeToFit];
        dateLabel.clipsToBounds =YES;
        [self addSubview:dateLabel];
        
        
        
        SOController *tempHandle = [GlobalInstances getNavigator];
        SOMainViewController *viewController = (SOMainViewController*) tempHandle.navigator.visibleViewController;

        
        //using collections to display tags
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 1;
        layout.itemSize = CGSizeMake(80,20);
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        layout.footerReferenceSize = CGSizeMake(80,20);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        tagsCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(countLabel.frame.size.width + countLabel.frame.origin.x + 5, titleLabel.frame.size.height + titleLabel.frame.origin.y + 5 , self.frame.size.width * 0.5, 30) collectionViewLayout:layout];
        [tagsCollection setDataSource:viewController];
        [tagsCollection setDelegate:viewController];
        [tagsCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [tagsCollection setBackgroundColor:[UIColor clearColor]];
        [self addSubview:tagsCollection];
        
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
