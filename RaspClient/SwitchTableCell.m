//
//  SwitchTableCell.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-13.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "SwitchTableCell.h"

@implementation SwitchTableCell

+(SwitchTableCell* )loadSwitchTableCellXib:(UITableView *)table{
    
    SwitchTableCell* cell;
    cell = (SwitchTableCell *)[table dequeueReusableCellWithIdentifier:@"SwitchTableCell"];
    if(cell == nil){
        
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = (SwitchTableCell *)[nib objectAtIndex:0];
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

- (void)setData:(Switch *)_switch{
    
    [_nameLabel setText:_switch.name];
    [_statusLabel setText:_switch.status.stringValue];
    [_levelLabel setText:_switch.status.stringValue];
}

@end
