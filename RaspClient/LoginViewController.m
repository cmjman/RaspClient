//
//  LoginViewController.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "LoginViewController.h"
#import "UserService.h"
#import "CurrentUser.h"

@interface LoginViewController (){
    
    CurrentUser* currentUser;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    currentUser = [CurrentUser sharedInstance];
    
    if ([currentUser isAutoLogin])
        [self performSegueWithIdentifier:@"gotoTab" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkLogin:(id)sender{
    
   [UserService checkUserLogin:_usernameText.text with:_passwordText.text callback:^(NSDictionary* json){
       
        if([[json objectForKey:@"result"] intValue ] == 1){
            
            NSDictionary* dictionary = [json objectForKey:@"user"];
            
            [currentUser setCurrentUser:dictionary];
            [currentUser setAutoLogin:_switchButton.on];
            [self performSegueWithIdentifier:@"gotoTab" sender:sender];
        }else{
            
            [[[UIAlertView alloc] initWithTitle:@"登录失败" message:@"请检查密码或者用户名" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }

    }];
    
    
}

- (IBAction)registUser:(id)sender{
    
    [UserService registUser:_usernameText.text with:_passwordText.text callback:^(NSDictionary* json){
        
        if([[json objectForKey:@"result"] intValue ] == 1){
            
            [[[UIAlertView alloc] initWithTitle:@"注册成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }else{
            
            [[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请换一个用户名" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }

    }];
}

@end
