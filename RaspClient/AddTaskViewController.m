//
//  AddTaskViewController.m
//  RaspClient
//
//  Created by ShiningChan on 14-5-5.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "AddTaskViewController.h"
#import "TaskService.h"

@interface AddTaskViewController (){
    
    NSArray* pickerData;
}

@end

@implementation AddTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_datePicker setMinimumDate:[NSDate date]];
    
    pickerData = @[@"temperature",@"humidity",@"<",@"<=",@"=",@">=",@">"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)commit:(id)sender{
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSDate* date = [_datePicker date];
    if (![date isEqual:[NSDate date]]){
        
        [dict setValue:[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]] forKey:@"time"];
    }
    
    NSInteger row=[_pickerView selectedRowInComponent:0];
    
    NSString *v1=[pickerData objectAtIndex:row];
    
    row=[_pickerView selectedRowInComponent:1];
    
    NSString *v2=[pickerData objectAtIndex:row+2];
    
    row=[_pickerView selectedRowInComponent:2];
    
    [dict setValue:[NSString stringWithFormat:@"%@%ld",v2,row] forKey:v1];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    NSString *JSONString;
    if (!jsonData) {
        NSLog(@"JSON error: %@",error);
    } else {
        
        JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    }
    
    [TaskService addTask:JSONString id:_text_id.text status:_text_status.text callback:^(NSDictionary* block){
        
    }];
    
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0){
        
        return 2;
    }else if(component == 1){
        return 5;
    }
    return 60;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(component == 0){
        
        return [pickerData objectAtIndex:row];
    }else if (component == 1){
        return [pickerData objectAtIndex:row+2];
    }
    
    return [NSString stringWithFormat:@"%ld",row];
}

@end
