//
//  TaskTableCell.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-18.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol TaskTableCell <NSObject>

@property (nonatomic, assign) CGFloat  finishedHeight;
@property (nonatomic, strong) UIColor *tintColor;

@end

@interface TaskTableCell : UITableViewCell <TaskTableCell>

@property (weak, nonatomic) IBOutlet UILabel* switchIdLabel;
@property (weak, nonatomic) IBOutlet UILabel* statusLabel;
@property (weak, nonatomic) IBOutlet UILabel* expressionLabel;
@property (weak, nonatomic) IBOutlet UILabel* resultLabel;
@property (strong, nonatomic) UITextField* textField;

+(TaskTableCell* )loadSwitchTableCellXib:(UITableView *)table;

-(void)setData:(Task *)task;

@end
