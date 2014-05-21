//
//  SwitchTableCell.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-13.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "SwitchTableCell.h"
#import "NSURL+ServerURL.h"
#import "SwitchService.h"
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
    
    _mswitch = _switch;
    
    [_nameLabel setText:_switch.name];
    
    [_uswitch setOn:[_switch.status boolValue]];
   
    [_levelLabel setText:_switch.level.stringValue];
    
    NSURL* imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",STATIC_IMAGE_URL,_switch.picture]];
    [_image setImageWithURL:imgUrl];
}

- (IBAction)doSwitch:(id)sender{
    
    [SwitchService changeSwitch:_mswitch.id callback:^(NSDictionary *json) {
        
        NSString* err = [json objectForKey:@"error"];
        if(err){
            [_uswitch setOn:[_mswitch.status boolValue]];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:err delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            
            _mswitch.status = [[NSNumber alloc] initWithInt:[_mswitch.status intValue]^1];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
    }];
}

@end
