//
//  SecondViewController.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-10.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewGestureRecognizer.h"

@interface TaskViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TableViewGestureEditingRowDelegate, TableViewGestureAddingRowDelegate>

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@end
