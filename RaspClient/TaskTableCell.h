//
//  TaskTableCell.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-18.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* switchIdLabel;
@property (weak, nonatomic) IBOutlet UILabel* statusLabel;
@property (weak, nonatomic) IBOutlet UILabel* expressionLabel;
@property (weak, nonatomic) IBOutlet UILabel* resultLabel;

+(TaskTableCell* )loadSwitchTableCellXib:(UITableView *)table;

-(void)setData:(Task *)task;

@end
