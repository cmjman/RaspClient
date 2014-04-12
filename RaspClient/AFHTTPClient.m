//
//  AFHTTPClient.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "AFHTTPClient.h"

static NSString * const SERVER_BASE_URL = @"http://192.168.1.111/service/";
//static NSString * const SERVER_BASE_URL = @"http://127.0.0.1:8080/service/";

@implementation AFHTTPClient

+ (instancetype)sharedClient {
    static AFHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVER_BASE_URL]];
    });
    
    return _sharedClient;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))failure{
    
    NSMutableURLRequest *modifiedRequest = request.mutableCopy;
    AFNetworkReachabilityManager *reachability = self.reachabilityManager;
    
    if (!reachability.isReachable){
        modifiedRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }else
        modifiedRequest.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
    
    //modifiedRequest.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    
    if ([request.HTTPMethod isEqualToString:@"GET"]){
        
        NSArray* arr =[[[NSString stringWithFormat:@"%@",request.URL] stringByReplacingOccurrencesOfString:SERVER_BASE_URL withString:@""] componentsSeparatedByString:@"?"];
        NSString* url= [arr objectAtIndex:0];
        NSString* parm =[NSString alloc];
        if ([arr count]>1)
            parm = [[[arr objectAtIndex:1] componentsSeparatedByString:@"="]objectAtIndex:1];
        else
            parm = @"";
        NSString* filename= [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",url,parm]];
        
        NSString* etag = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
        
        if (etag != nil){
            
            NSMutableDictionary* mDict = [modifiedRequest.allHTTPHeaderFields mutableCopy];
            [mDict setObject:etag forKey:@"If-None-Match"];
            modifiedRequest.allHTTPHeaderFields = mDict;
        }
    }
       
    return [super HTTPRequestOperationWithRequest:modifiedRequest
                                          success:success
                                          failure:failure];
}

@end
