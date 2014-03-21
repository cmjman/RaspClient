//
//  CurrentUser.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-15.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface CurrentUser : NSObject

+ (instancetype)sharedInstance;

- (void)setCurrentUser:(NSDictionary *)userJson;

- (User*)getCurrentUser;

- (void)setAutoLogin:(BOOL)isAuto;

- (BOOL)isAutoLogin;

@end
