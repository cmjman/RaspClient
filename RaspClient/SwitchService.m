//
//  SwitchService.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "SwitchService.h"
#import "NSURL+ServerURL.h"

@implementation SwitchService

+ (AFHTTPRequestOperation *)getSwitch:(NSNumber *)page callback:(void (^)(NSDictionary *))block{
    
    NSDictionary *dictionary = @{@"page":page};
    NSString* url = @"switch";
    
    return [[AFHTTPClient sharedClient] GET:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"%i",operation.response.statusCode);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* filename= [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[operation.request.URL suffix]]];
        
        [NSKeyedArchiver archiveRootObject:[operation.response.allHeaderFields objectForKey:@"Etag"] toFile:filename];
        if (block) {
            block(responseObject);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        if (operation.response.statusCode == 304){
            
            if (block) {
                
                NSDictionary* dict= [[AFHTTPClient sharedClient] cachedResponseObject:operation];
                block(dict);
            }
        }
    }];
}

+ (AFHTTPRequestOperation *)changeSwitch:(NSNumber *)switchId callback:(void (^)(NSDictionary *))block{
    
    NSDictionary *dictionary = @{@"switch_id":switchId};
    NSString* url = @"switch";
    
    return [[AFHTTPClient sharedClient] PUT:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (block) {
            block(responseObject);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        NSDictionary* dict = @{@"error":[error debugDescription]};
        
        if (block) {
            block(dict);
        }
    }];
}

@end
