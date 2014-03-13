//
//  FirstViewController.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-10.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "SwitchViewController.h"
#import "SwitchTableCell.h"
#import "SwitchService.h"
#import "Switch.h"

@interface SwitchViewController (){
    
    NSMutableArray* dataArray;
}

@end

@implementation SwitchViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [SwitchService getSwitch:[[NSNumber alloc] initWithInt:1] callback:^(NSDictionary* json){
        
        NSLog(@"%@",json);
        
        NSArray* array = [json objectForKey:@"switches"];
        dataArray = [NSMutableArray array];
        
        for(NSDictionary* obj in array){
            
          
            NSError* err = nil;
            Switch* _switch = [[Switch alloc] initWithDictionary:obj error:&err];
          
            [dataArray addObject:_switch];
            [_tableView reloadData];
        }
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  //  NSLog(@"%@",[dataArray count]);
    return [dataArray count];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* identifier = [NSString stringWithFormat:@"SwitchTableCell"];
    SwitchTableCell* cell = (SwitchTableCell* )[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [SwitchTableCell loadSwitchTableCellXib:tableView];
    }
    
    Switch* _switch = [dataArray objectAtIndex:indexPath.row];
    
    [cell setData:_switch];

    return cell;
}

@end
