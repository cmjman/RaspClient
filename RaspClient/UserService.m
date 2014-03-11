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

+(void)checkUserLogin:(NSString *)userName with:(NSString *)password{
    
    NSDictionary *dictionary = @{userName:@"nick",password:@"password"};
    
    [[AFHTTPClient sharedClient] POST:@"login" parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"%@",responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
