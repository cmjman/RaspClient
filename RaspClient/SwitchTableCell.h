//
//  SwitchTableCell.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-13.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Switch.h"

@interface SwitchTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* statusLabel;
@property (weak, nonatomic) IBOutlet UILabel* levelLabel;

+(SwitchTableCell* )loadSwitchTableCellXib:(UITableView *)table;

-(void)setData:(Switch *)_switch;

@end
