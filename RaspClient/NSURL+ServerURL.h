//
//  NSURL+ServerURL.h
//  RaspClient
//
//  Created by ShiningChan on 14-4-15.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ServerURL)

#define WEBSERVICE_URL @"http://192.168.1.114/service/"
#define STATIC_IMAGE_URL @"http://192.168.1.114/static/img/"

-(NSString *)suffix;

@end
