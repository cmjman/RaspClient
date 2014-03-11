//
//  AFHTTPClient.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "AFHTTPClient.h"

//static NSString * const SERVER_BASE_URL = @"http://192.168.1.115/service/";
static NSString * const SERVER_BASE_URL = @"http://127.0.0.1:8080/service/";

@implementation AFHTTPClient

+ (instancetype)sharedClient {
    static AFHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVER_BASE_URL]];
    });
    
    return _sharedClient;
}

@end
