//
//  AFHTTPClient.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "AFHTTPClient.h"
#import "NSURL+ServerURL.h"

@implementation AFHTTPClient

+ (instancetype)sharedClient {
    static AFHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:WEBSERVICE_URL]];
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
    }
    else{
        modifiedRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    
    if ([request.HTTPMethod isEqualToString:@"GET"]){
        
        NSString* filename= [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[request.URL suffix]]];
        
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

- (id)cachedResponseObject:(AFHTTPRequestOperation *)operation{
    

    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:operation.request];
            
    AFHTTPResponseSerializer* serializer = [AFJSONResponseSerializer serializer];
            
    id responseObject = [serializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
    
    return responseObject;
}

@end
