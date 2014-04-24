//
//  UserService.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "UserService.h"
#import "AFHTTPClient.h"

@implementation UserService

+(AFHTTPRequestOperation *)checkUserLogin:(NSString *)userName with:(NSString *)password callback:(void (^)(NSDictionary *json))block {
    
    NSDictionary *dictionary = @{@"nick":userName,@"password":password};
    
    return [[AFHTTPClient sharedClient] GET:@"user" parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (block) {
            block(responseObject);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

+(AFHTTPRequestOperation *)registUser:(NSString *)userName with:(NSString *)password callback:(void (^)(NSDictionary *json))block{
    
    NSDictionary *dictionary = @{@"nick":userName,@"password":password};
    
    return [[AFHTTPClient sharedClient] POST:@"user" parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject){
    
        if (block) {
            block(responseObject);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

@end
