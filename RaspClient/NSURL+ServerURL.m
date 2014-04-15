//
//  NSURL+ServerURL.m
//  RaspClient
//
//  Created by ShiningChan on 14-4-15.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "NSURL+ServerURL.h"

@implementation NSURL (ServerURL)

-(NSString *)suffix{
    
    NSString* suffix = [[NSString stringWithFormat:@"%@",self] stringByReplacingOccurrencesOfString:WEBSERVICE_URL withString:@""];
    
    return suffix;
}

@end
