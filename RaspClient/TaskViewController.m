//
//  SecondViewController.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-10.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskTableCell.h"
#import "TaskService.h"
#import "Task.h"

@interface TaskViewController (){
    
    NSMutableArray* dataArray;
}

@end

@implementation TaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _tableView.delegate = self;
    _tableView.dataSource = self;

    //iOS 7下首个cell位置会向上偏移64个像素，需要手动调整
    for(UIView *subview in _tableView.subviews){
        
        if([NSStringFromClass([subview class]) isEqualToString:@"UITableViewWrapperView"]){
            
            subview.frame = CGRectMake(0, 64, _tableView.bounds.size.width, _tableView.bounds.size.height);
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.tabBarController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask:)]];
    
    [TaskService getTask:[[NSNumber alloc] initWithInt:1] callback:^(NSDictionary* json){
        
        NSLog(@"%@",json);
        
        NSArray* array = [json objectForKey:@"tasks"];
        dataArray = [NSMutableArray array];
        
        for(NSDictionary* obj in array){
            
            NSError* err = nil;
            Task* task = [[Task  alloc] initWithDictionary:obj error:&err];
            
            if (task == nil)
                NSLog(@"%@",err);
            
            [dataArray addObject:task];
        }
        
         [_tableView reloadData];
    }];

}

- (void)viewDidDisappear:(BOOL)animated{
    
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (void)addTask:(id)sender{
    
    [self performSegueWithIdentifier:@"gotoAddTask" sender:sender];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //  NSLog(@"%@",[dataArray count]);
    return [dataArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    [view setBackgroundColor:[UIColor blackColor]];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 320, 44)];
    [label setText:@"ID    状态   条件表达式                       操作结果"];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:label];
    
    return view;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = nil;
    TaskTableCell *cell = nil;
    
    identifier = [NSString stringWithFormat:@"TaskTableCell"];
    cell = (TaskTableCell* )[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [TaskTableCell loadSwitchTableCellXib:tableView];
    }
    
    Task* task = [dataArray objectAtIndex:indexPath.row];
    
    [cell setData:task];
    
    return cell;
}
@end
