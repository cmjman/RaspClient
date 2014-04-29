//
//  SensorViewController.m
//  RaspClient
//
//  Created by ShiningChan on 14-4-19.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "SensorViewController.h"

@interface SensorViewController (){
    
    NSURLRequest* request;
}

@end

@implementation SensorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self setOrientation:UIInterfaceOrientationLandscapeLeft];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getNetworkTypeWithPrivateFramework];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [self setOrientation:UIInterfaceOrientationPortrait];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//仅真机有效，模拟器需要补充
- (void)getNetworkTypeWithPrivateFramework{
    
    NSBundle *bundle = [NSBundle bundleWithPath:
                        @"/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework"];
                   
    if ([bundle load]){
        
        Class NetworkMonitor = NSClassFromString(@"SUNetworkMonitor");
        id pointer = [[NetworkMonitor alloc] init];
        if ([pointer respondsToSelector:@selector(currentNetworkType)]){
            
            int i = (int)[pointer performSelector:@selector(currentNetworkType)];
            
            NSString *type = @"";
            switch (i) {
                case 0:  type = @"NO-DATA"; break;
                case 1:  type = @"WIFI"; break;
                case 2:  type = @"GPRS/EDGE"; break;
                case 3:  type = @"3G"; break;
                default: type = @"OTHERS"; break;
            }
            
            NSLog(@"Network type: %@", type);
        }
    }
}

- (void)setOrientation:(NSUInteger)orientation {
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
