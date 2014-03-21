//
//  TableViewGestureRecognizer.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-19.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TableViewCellEditingStateMiddle,
    TableViewCellEditingStateLeft,
    TableViewCellEditingStateRight,
}TableViewCellEditingState;

extern CGFloat const TableViewCommitEditingRowDefaultLength;

extern CGFloat const TableViewRowAnimationDuration;

@protocol TableViewGestureAddingRowDelegate;
@protocol TableViewGestureEditingRowDelegate;

@interface TableViewGestureRecognizer : NSObject<UITableViewDelegate>

@property (nonatomic, weak, readonly) UITableView *tableView;

+(TableViewGestureRecognizer *)gestureRecognizerWithTableView:(UITableView *)tableView delegate:(id)delegate;

@end

@protocol TableViewGestureAddingRowDelegate <NSObject>

- (void)gestureRecognizer:(TableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(TableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(TableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSIndexPath *)gestureRecognizer:(TableViewGestureRecognizer *)gestureRecognizer willCreateCellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)gestureRecognizer:(TableViewGestureRecognizer *)gestureRecognizer heightForCommittingRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol TableViewGestureEditingRowDelegate <NSObject>

- (BOOL)gestureRecognizer:(TableViewGestureRecognizer *)gestureRecognizer canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(TableViewGestureRecognizer *)gestureRecognizer didEnterEditingState:(TableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(TableViewGestureRecognizer *)gestureRecognizer commitEditingState:(TableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (CGFloat)gestureRecognizer:(TableViewGestureRecognizer *)gestureRecognizer lengthForCommitEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(TableViewGestureRecognizer *)gestureRecognizer didChangeContentViewTranslation:(CGPoint)translation forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface UITableView (TableViewGestureDelegate)

- (TableViewGestureRecognizer *)enableGestureTableViewWithDelegate:(id)delegate;

// Helper methods for updating cell after datasource changes
- (void)reloadVisibleRowsExceptIndexPath:(NSIndexPath *)indexPath;

@end

