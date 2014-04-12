//
//  SwitchService.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "SwitchService.h"

@implementation SwitchService

+ (AFHTTPRequestOperation *)getSwitch:(NSNumber *)page callback:(void (^)(NSDictionary *))block{
    
    NSDictionary *dictionary = @{@"page":page};
    NSString* url = @"getSwitch";
    
    return [[AFHTTPClient sharedClient] GET:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"%i",operation.response.statusCode);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* filename= [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",url,page]];
        
        [NSKeyedArchiver archiveRootObject:[operation.response.allHeaderFields objectForKey:@"Etag"] toFile:filename];
        if (block) {
            block([responseObject objectForKey:@"response"]);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

@end
