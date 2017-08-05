//
//  SOMainViewController.m
//  stackOverflowiOS
//
//  Created by Ronald Kimutai on 04/08/2017.
//  Copyright © 2017 test ltd. All rights reserved.
//

#import "SOMainViewController.h"
#import "SOController.h"
#import "GlobalInstances.h"
#import "SOQuestionsTableViewCell.h"
#import "DateTools.h"
#import "UIColor+CustomColors.h"

@interface SOMainViewController (){
    
    UITableView *questionsTableView;
    SOController *tempHandle;
    UINavigationController *tempNavigator;
    NSMutableArray *responseArray, *tagsArray;
    float collectionCellHeight, collectionCellWidth;
    UIRefreshControl *refreshControl;
    
}
@end

@implementation SOMainViewController

@synthesize viewObject,activityIndicator,apiObject;

-(void)loadView
{
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.barTintColor =[UIColor orangeColor];
    
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    
    self.navigationItem.title = @"Stack Overflow";
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setTintColor:[UIColor orangeColor]];
    viewObject = [[SOMainView alloc] init];
    [viewObject loadScreen];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view = viewObject;
    
    tempHandle =[GlobalInstances getNavigator];
    tempNavigator = tempHandle.navigator;
    
    questionsTableView = (UITableView*)[self.view viewWithTag:1];
    questionsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    questionsTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    responseArray = [[NSMutableArray alloc] init];
    
    
    // show activity indicator
    [self showActivityMonitor];
    //call method to fetch table's data
    [self fetchData];
    
    questionsTableView.tableFooterView = [UIView new];
    
    //add pull to refresh on the tableView
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor orangeColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [questionsTableView insertSubview:refreshControl atIndex:0];
    
}


#pragma mark fetching data source

-(void)fetchData{
    
    //initiate api call
    apiObject = [[APIClient alloc] initFetchQuestions];
    apiObject.delegate = self;
}

#pragma mark APIClient delegate methods

-(void)jsonParsedData:(NSMutableDictionary *)data
{
    //hide the activity indicator
    [self removeActivityMonitor];
    
    if([data count]>0){
        NSMutableDictionary *responseDictionary = [data objectForKey:@"SERVICERESPONSE"];
       
        if([[responseDictionary objectForKey:@"responseCode"] isEqualToString:@"00"] )
        {
            
            responseArray =  [responseDictionary objectForKey:@"items"];
            
            //reload the table view to update records
            [questionsTableView reloadData];
        }
        else{
            
            //API failed to return response, alert user
        }
    }
}


#pragma mark table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  100;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [responseArray count];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return nil;
}


- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.bounds.size.width, 30)];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    headerLabel.textAlignment =NSTextAlignmentLeft;
    headerLabel.text = @"Questions tagged \"iOS\"";

    return headerLabel;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([responseArray count]>0){
        
        //load the UITableViewCell - SOTableViewCell.h
        SOQuestionsTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"ItemsList"];
        customCell = [[SOQuestionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemsList"];
        
        // Gets tags
        tagsArray  = [[responseArray objectAtIndex:indexPath.row] valueForKey:@"tags"];
        
        // Gets is_answered
        bool isAnswered = [[[responseArray objectAtIndex:indexPath.row] valueForKey:@"is_answered"] boolValue];
        
        // Gets answer Count
        int answerCount  = [[[responseArray objectAtIndex:indexPath.row] valueForKey:@"answer_count"] intValue];
        
        //gets creation date
        double creationDate = [[[responseArray objectAtIndex:indexPath.row] valueForKey:@"creation_date"] doubleValue];
        
        //gets title
        NSString *title = [[responseArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        
        
        //Using 3rd party lib DateTools
        //formatting the received creation timestamp to show time in descriptive format
        
        NSTimeInterval _interval = creationDate;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //set input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *newDate = [dateFormatter stringFromDate:date];
        
        customCell.titleLabel.text = title;
        customCell.dateLabel.text = [dateFormatter dateFromString:newDate].timeAgoSinceNow ;
        customCell.countLabel.text = [NSString stringWithFormat:@"%d",answerCount];
        
        if (answerCount != 1) {
            customCell.answerLabel.text = @"Answers";
        }
        
        if (isAnswered){
            customCell.countLabel.backgroundColor =[UIColor customGreen];
        }
        
        [customCell.titleLabel sizeToFit];
        
        //set tags data to the collectionView
        customCell.tagsCollection.delegate = self;
        customCell.tagsCollection.dataSource = self;
        [customCell.tagsCollection reloadData];
        
        return customCell;
    }
    else
    {
        return nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect
    [questionsTableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark collection view delegate methods

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,5, cell.frame.size.width , cell.frame.size.height)];
    titleLabel.text = [tagsArray objectAtIndex:indexPath.row];
    titleLabel.backgroundColor = [UIColor customLightGray];
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    titleLabel.clipsToBounds = YES;
    titleLabel.layer.cornerRadius = 4;
    [cell addSubview:titleLabel];
    cell.backgroundColor=[UIColor clearColor]; //uses CustomColors - UIColor+CustomColors.h
   
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [(NSString*)[tagsArray objectAtIndex:indexPath.row] sizeWithAttributes:NULL];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [tagsArray count];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
       
}


#pragma mark activityIndicator methods

-(void)showActivityMonitor
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float screenWidth = screenRect.size.width;
    float screenHeight = screenRect.size.height-[GlobalInstances getNavigationBarHeight]-[UIApplication sharedApplication].statusBarFrame.size.height;
    
    float actW = 100;
    float actH = 100;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((screenWidth/2)-(actW/2), (screenHeight/2)-(actH/2), actW, actH)];
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    activityIndicator.layer.cornerRadius = 16;
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
}


-(void)removeActivityMonitor
{
    //dismiss the activity indicator
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    activityIndicator.hidden =YES;
    activityIndicator = nil;
    
    //dismiss UIRefreshControl
    [refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
