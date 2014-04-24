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
    SRWebSocket *webSocket;
}

@end

static NSString * const SWITCH_STATUS_URL = @"http://127.0.0.1:8080/service/getSwitchStatus";

@implementation SwitchViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [SwitchService getSwitch:[[NSNumber alloc] initWithInt:1] callback:^(NSDictionary* json){
        
        //NSLog(@"%@",json);
        
        NSArray* array = [json objectForKey:@"switches"];
        dataArray = [NSMutableArray array];
        
        for(NSDictionary* obj in array){
            
          
            NSError* err = nil;
            Switch* _switch = [[Switch alloc] initWithDictionary:obj error:&err];
          
            [dataArray addObject:_switch];
            [_tableView reloadData];
        }
    }];
    
    [self connect];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}

- (void)connect{
    
    webSocket.delegate = nil;
    [webSocket close];
    
    webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SWITCH_STATUS_URL]]];
    
    webSocket.delegate = self;
    
    NSLog(@"Opening Connection...");
    [webSocket open];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 44)];
    [label setText:@" 图片     开关名称             状态              操作权限"];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:label];
    
    return view;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"gotoSensor" sender:self];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;{
    NSLog(@"Websocket Connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;{
    NSLog(@"Received \"%@\"", message);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;{
    NSLog(@"WebSocket closed");
    webSocket = nil;
}

@end
