//
//  APIClient.m
//  stackOverflowiOS
//
//  Created by Ronald Kimutai on 04/08/2017.
//  Copyright © 2017 test ltd. All rights reserved.
//

#import "APIClient.h"

#define QUESTIONSDATA 1
#define RESPONSE_ERROR 99

@implementation APIClient

@synthesize responseData, serialisedResultData, resultDict, responseType;

-(id) initFetchQuestions{
    
    if( self = [super init] )
    {
        
        responseType = QUESTIONSDATA;
        [self callService:apiUrl];
        
    }
    return self;

}


-(void)callService:(NSString*)urlstr
{
    @try
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:urlstr]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        if (theConnection)
        {
            
            responseData = nil;
        }
    }
    @catch(NSException *e)
    {
        
    }

}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //  //NSLog(@"Did receive res for %d",responseType);
    
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    NSHTTPURLResponse *aResponse = (NSHTTPURLResponse *)response;
    
    NSLog(@"statusCodeResponse: %ld", (long)aResponse.statusCode);
    
    NSString *strError = [NSString stringWithFormat:@"%@", [connection description]];
    
    ////NSLog(@"strError: %@", strError);
    
    responseData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
    
}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    if (responseData) {
        NSError *localError = nil;
        serialisedResultData = [[NSMutableData alloc] init];
        serialisedResultData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&localError];
        if (localError != nil)
        {
            responseType = RESPONSE_ERROR;
            
        }
       
        switch (responseType)
        {
            case RESPONSE_ERROR:
                
                [self getServiceErrorResponse];
                [self.delegate jsonParsedData:resultDict];
                responseType = 0;
                
            break;
            case QUESTIONSDATA:
                
                [self getStackOverflowResponse];
                [self.delegate jsonParsedData:resultDict];
                responseType = 0;
                
            break;
            default:
                break;
        }
    }else if (!responseData){
        [self.delegate jsonParsedData:resultDict];
        
    }
}


#pragma mark stackOverflow response parsing

-(void) getStackOverflowResponse {
   
    resultDict = [[NSMutableDictionary alloc] init];
    [resultDict setObject:[[NSMutableDictionary alloc] init] forKey:@"SERVICERESPONSE"];
    
    if(nil != serialisedResultData)
    {
        NSDictionary *items =[serialisedResultData valueForKey:@"items"];
        if (!items) {
            // An error occured - examine 'error'
        }
        
        NSMutableDictionary *details = [resultDict objectForKey:@"SERVICERESPONSE"];
        if(items){
            
            [details setObject:items forKey:@"items"];
            [details setObject:@"00" forKey:@"responseCode"]; //set success response code 00
        }
        else{
            [details setObject:@"01" forKey:@"responseCode"]; //set fail response code 01 for empty items
        }
    }
    
}



-(void) getServiceErrorResponse{
    
    resultDict = [[NSMutableDictionary alloc] init];
    [resultDict setObject:[[NSMutableDictionary alloc] init] forKey:@"SERVICERESPONSE"];

    NSString *responseCode =@"01"; // Sets responseCode    
    NSMutableDictionary *details = [resultDict objectForKey:@"SERVICERESPONSE"];
    [details setObject:responseCode forKey:@"responseCode"];
    
    
}

@end
