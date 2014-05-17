//
//  AddTaskViewController.h
//  RaspClient
//
//  Created by ShiningChan on 14-5-5.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTaskViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker* datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView* pickerView;
@property (weak, nonatomic) IBOutlet UIButton* button;
@property (weak, nonatomic) IBOutlet UITextField* text_id;
@property (weak, nonatomic) IBOutlet UITextField* text_status;

@end
