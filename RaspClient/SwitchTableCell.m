//
//  SwitchTableCell.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-13.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "SwitchTableCell.h"
#import "ServerUrl.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SwitchTableCell

+(SwitchTableCell* )loadSwitchTableCellXib:(UITableView *)table{
    
    SwitchTableCell* cell;
    cell = (SwitchTableCell *)[table dequeueReusableCellWithIdentifier:@"SwitchTableCell"];
    if(cell == nil){
        
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
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
    
    NSString* status_text = [_switch.status intValue] == 1?@"On":@"Off";
    [_statusLabel setText:status_text];
    [_levelLabel setText:_switch.level.stringValue];
    
    NSURL* imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",STATIC_IMAGE_URL,_switch.picture]];
    [_image setImageWithURL:imgUrl];
}

@end
