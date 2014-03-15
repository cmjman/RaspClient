//
//  FirstViewController.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-10.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"

@interface SwitchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SRWebSocketDelegate>

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@end
