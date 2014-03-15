//
//  TaskService.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "TaskService.h"

@implementation TaskService

+(AFHTTPRequestOperation*)getTask:(NSNumber *)page callback:(void (^)(NSDictionary *))block{
    
    NSDictionary *dictionary = @{@"page":page};
    
    return [[AFHTTPClient sharedClient] GET:@"getTask" parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (block) {
            block([responseObject objectForKey:@"response"]);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

@end
