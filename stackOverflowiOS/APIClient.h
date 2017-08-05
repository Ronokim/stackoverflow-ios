//
//  APIClient.h
//  stackOverflowiOS
//
//  Created by Ronald Kimutai on 04/08/2017.
//  Copyright © 2017 test ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol apiDelegate;

@interface APIClient : NSObject<NSURLConnectionDelegate>
{
    
}
@property(nonatomic,readwrite)NSMutableData *responseData;
@property(nonatomic,readwrite)NSMutableData *serialisedResultData;
@property(nonatomic,readwrite)NSMutableDictionary *resultDict;
@property(nonatomic,readwrite)int responseType;

@property(nonatomic,weak) id<apiDelegate> delegate;

-(id) initFetchQuestions;
@end

@protocol apiDelegate
- (void)jsonParsedData:(NSMutableDictionary*)data;
@end
