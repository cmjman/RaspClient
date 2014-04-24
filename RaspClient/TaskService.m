//
//  TaskService.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "TaskService.h"
#import "CurrentUser.h"
#import "NSURL+ServerURL.h"
#import "AFURLResponseSerialization.h"

@implementation TaskService

+(AFHTTPRequestOperation*)getTask:(NSNumber *)page callback:(void (^)(NSDictionary *))block{
    
    User* user = [[CurrentUser sharedInstance] getCurrentUser];
    NSDictionary *dictionary = @{@"page":page,@"user_id":user.id};

    return [[AFHTTPClient sharedClient] GET:@"task" parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject){
        
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

@end
