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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //  NSLog(@"%@",[dataArray count]);
    return [dataArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    [view setBackgroundColor:[UIColor blackColor]];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 320, 44)];
    [label setText:@"任务ID           目标状态                操作结果"];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:label];
    
    return view;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
    NSObject *object = [dataArray objectAtIndex:indexPath.row];
    
    NSString *identifier = nil;
    TaskTableCell *cell = nil;
    

    
    identifier = [NSString stringWithFormat:@"TaskTableCell"];
    cell = (TaskTableCell* )[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [TaskTableCell loadSwitchTableCellXib:tableView];
    }
    
    Task* task = [dataArray objectAtIndex:indexPath.row];
    
    [cell setData:task];
     */
    
    NSString* CellIdentifier=@"TaskTableCell";
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // Remove inset of iOS 7 separators.
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        // Setting the background color of the cell.
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    // Configuring the views and colors.
    UIView *checkView = [self viewWithImageName:@"check"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    UIView *clockView = [self viewWithImageName:@"clock"];
    UIColor *yellowColor = [UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    
    UIView *listView = [self viewWithImageName:@"list"];
    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    // Setting the default inactive state color to the tableView background color.
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    [cell.textLabel setText:@"Switch Mode Cell"];
    [cell.detailTextLabel setText:@"Swipe to switch"];
    
    // Adding gestures per state basis.
    [cell setSwipeGestureWithView:checkView color:greenColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Checkmark\" cell");
    }];
    
    [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Cross\" cell");
    }];
    
    [cell setSwipeGestureWithView:clockView color:yellowColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Clock\" cell");
    }];
    
    [cell setSwipeGestureWithView:listView color:brownColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"List\" cell");
    }];
    
    return cell;
}
@end
