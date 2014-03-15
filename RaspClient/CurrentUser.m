//
//  CurrentUser.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-15.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "CurrentUser.h"

@implementation CurrentUser

NSUserDefaults* accountDefaults;

+ (instancetype)sharedInstance{
    static CurrentUser *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CurrentUser alloc] init];
        accountDefaults = [NSUserDefaults standardUserDefaults];
    });
    
    return _sharedInstance;
}

-(void)setCurrentUser:(NSDictionary *)userJson{
    
    [accountDefaults setObject:userJson forKey:@"userinfo"];
}

-(User*)getCurrentUser{
    
    NSDictionary* json = [accountDefaults objectForKey:@"userinfo"];
    User* user = [[User alloc] initWithDictionary:json  error:nil];
    return user;
}

@end
