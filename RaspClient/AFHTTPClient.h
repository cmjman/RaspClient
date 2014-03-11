//
//  AFHTTPClient.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AFHTTPClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end
