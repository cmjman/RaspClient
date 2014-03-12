//
//  FirstViewController.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-10.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "SwitchViewController.h"

@interface SwitchViewController (){
    
    NSMutableArray* dataArray;
}

@end

@implementation SwitchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [dataArray count];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end
