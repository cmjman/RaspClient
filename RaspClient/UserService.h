//
//  UserService.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserService : NSObject

+(void)checkUserLogin:(NSString *)userName with: (NSString *)password;

@end
