//
//  TaskTableCell.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-18.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "TaskTableCell.h"

@implementation TaskTableCell
@synthesize finishedHeight, tintColor;


+(TaskTableCell* )loadSwitchTableCellXib:(UITableView *)table{
    
    TaskTableCell* cell;
    cell = (TaskTableCell *)[table dequeueReusableCellWithIdentifier:@"TaskTableCell"];
    if(cell == nil){
        
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = [nib objectAtIndex:1];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Task *)task{
    
    [_switchIdLabel setText:task.switch_id.stringValue];
    [_statusLabel setText:task.target_status.stringValue];
    [_expressionLabel setText:task.if_expression];
    [_resultLabel setText:task.result.stringValue];
}

@end
