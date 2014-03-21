//
//  TableViewGestureRecognizer.m
//  RaspClient
//
//  Created by ShiningChan on 14-3-19.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import "TableViewGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    TableViewGestureRecognizerStateNone,
    TableViewGestureRecognizerStateDragging,
    TableViewGestureRecognizerStatePinching,
    TableViewGestureRecognizerStatePanning,
    TableViewGestureRecognizerStateMoving,
}TableViewGestureRecognizerState;

CGFloat const TableViewCommitEditingRowDefaultLength = 80;
CGFloat const TableViewRowAnimationDuration          = 0.25;

@interface TableViewGestureRecognizer () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <TableViewGestureAddingRowDelegate, TableViewGestureEditingRowDelegate> delegate;
@property (nonatomic, weak) id <UITableViewDelegate>         tableViewDelegate;
@property (nonatomic, weak) UITableView                     *tableView;
@property (nonatomic, assign) CGFloat                        addingRowHeight;
@property (nonatomic, strong) NSIndexPath                   *addingIndexPath;
@property (nonatomic, assign) TableViewCellEditingState    addingCellState;
@property (nonatomic, assign) CGPoint                        startPinchingUpperPoint;
@property (nonatomic, strong) UIPinchGestureRecognizer      *pinchRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer        *panRecognizer;
@property (nonatomic, assign) TableViewGestureRecognizerState state;
@property (nonatomic, strong) UIImage                       *cellSnapshot;
@property (nonatomic, assign) CGFloat                        scrollingRate;
@property (nonatomic, strong) NSTimer                       *movingTimer;

- (void)updateAddingIndexPathForCurrentLocation;
- (void)commitOrDiscardCell;

@end

#define CELL_SNAPSHOT_TAG 100000

@implementation TableViewGestureRecognizer

- (void)commitOrDiscardCell {
    if (self.addingIndexPath) {
        UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:self.addingIndexPath];
        [self.tableView beginUpdates];
        
        
        CGFloat commitingCellHeight = self.tableView.rowHeight;
        if ([self.delegate respondsToSelector:@selector(gestureRecognizer:heightForCommittingRowAtIndexPath:)]) {
            commitingCellHeight = [self.delegate gestureRecognizer:self
                                 heightForCommittingRowAtIndexPath:self.addingIndexPath];
        }
        
        if (cell.frame.size.height >= commitingCellHeight) {
            [self.delegate gestureRecognizer:self needsCommitRowAtIndexPath:self.addingIndexPath];
        } else {
            [self.delegate gestureRecognizer:self needsDiscardRowAtIndexPath:self.addingIndexPath];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.addingIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        }
        
        // We would like to reload other rows as well
        [self.tableView performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:self.addingIndexPath afterDelay:TableViewRowAnimationDuration];
        
        self.addingIndexPath = nil;
        [self.tableView endUpdates];
        
        // Restore contentInset while touch ends
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];  // Should not be less than the duration of row animation
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [UIView commitAnimations];
        
    }
    self.state = TableViewGestureRecognizerStateNone;
}

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer {
    //    NSLog(@"%d %f %f", [recognizer numberOfTouches], [recognizer velocity], [recognizer scale]);
    if (recognizer.state == UIGestureRecognizerStateEnded || [recognizer numberOfTouches] < 2) {
        if (self.addingIndexPath) {
            [self commitOrDiscardCell];
        }
        return;
    }
    
    CGPoint location1 = [recognizer locationOfTouch:0 inView:self.tableView];
    CGPoint location2 = [recognizer locationOfTouch:1 inView:self.tableView];
    CGPoint upperPoint = location1.y < location2.y ? location1 : location2;
    
    CGRect  rect = (CGRect){location1, location2.x - location1.x, location2.y - location1.y};
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSAssert(self.addingIndexPath != nil, @"self.addingIndexPath must not be nil, we should have set it in recognizerShouldBegin");
        
        self.state = TableViewGestureRecognizerStatePinching;
        
        // Setting up properties for referencing later when touches changes
        self.startPinchingUpperPoint = upperPoint;
        
        // Creating contentInset to fulfill the whole screen, so our tableview won't occasionaly
        // bounds back to the top while we don't have enough cells on the screen
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.frame.size.height, 0, self.tableView.frame.size.height, 0);
        
        [self.tableView beginUpdates];
        
        [self.delegate gestureRecognizer:self needsAddRowAtIndexPath:self.addingIndexPath];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:self.addingIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat diffRowHeight = CGRectGetHeight(rect) - CGRectGetHeight(rect)/[recognizer scale];
        
        //        NSLog(@"%f %f %f", CGRectGetHeight(rect), CGRectGetHeight(rect)/[recognizer scale], [recognizer scale]);
        if (self.addingRowHeight - diffRowHeight >= 1 || self.addingRowHeight - diffRowHeight <= -1) {
            self.addingRowHeight = diffRowHeight;
            [self.tableView reloadData];
        }
        
        // Scrolls tableview according to the upper touch point to mimic a realistic
        // dragging gesture
        CGPoint newUpperPoint = upperPoint;
        CGFloat diffOffsetY = self.startPinchingUpperPoint.y - newUpperPoint.y;
        CGPoint newOffset   = (CGPoint){self.tableView.contentOffset.x, self.tableView.contentOffset.y+diffOffsetY};
        [self.tableView setContentOffset:newOffset animated:NO];
    }
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    if ((recognizer.state == UIGestureRecognizerStateBegan
         || recognizer.state == UIGestureRecognizerStateChanged)
        && [recognizer numberOfTouches] > 0) {
        
        // TODO: should ask delegate before changing cell's content view
        
        CGPoint location1 = [recognizer locationOfTouch:0 inView:self.tableView];
        
        NSIndexPath *indexPath = self.addingIndexPath;
        if ( ! indexPath) {
            indexPath = [self.tableView indexPathForRowAtPoint:location1];
            self.addingIndexPath = indexPath;
        }
        
        self.state = TableViewGestureRecognizerStatePanning;
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        CGPoint translation = [recognizer translationInView:self.tableView];
        cell.contentView.frame = CGRectOffset(cell.contentView.bounds, translation.x, 0);
        
        if ([self.delegate respondsToSelector:@selector(gestureRecognizer:didChangeContentViewTranslation:forRowAtIndexPath:)]) {
            [self.delegate gestureRecognizer:self didChangeContentViewTranslation:translation forRowAtIndexPath:indexPath];
        }
        
        CGFloat commitEditingLength = TableViewCommitEditingRowDefaultLength;
        if ([self.delegate respondsToSelector:@selector(gestureRecognizer:lengthForCommitEditingRowAtIndexPath:)]) {
            commitEditingLength = [self.delegate gestureRecognizer:self lengthForCommitEditingRowAtIndexPath:indexPath];
        }
        if (fabsf(translation.x) >= commitEditingLength) {
            if (self.addingCellState == TableViewCellEditingStateMiddle) {
                self.addingCellState = translation.x > 0 ? TableViewCellEditingStateRight : TableViewCellEditingStateLeft;
            }
        } else {
            if (self.addingCellState != TableViewCellEditingStateMiddle) {
                self.addingCellState = TableViewCellEditingStateMiddle;
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(gestureRecognizer:didEnterEditingState:forRowAtIndexPath:)]) {
            [self.delegate gestureRecognizer:self didEnterEditingState:self.addingCellState forRowAtIndexPath:indexPath];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        NSIndexPath *indexPath = self.addingIndexPath;
        
        // Removes addingIndexPath before updating then tableView will be able
        // to determine correct table row height
        self.addingIndexPath = nil;
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGPoint translation = [recognizer translationInView:self.tableView];
        
        CGFloat commitEditingLength = TableViewCommitEditingRowDefaultLength;
        if ([self.delegate respondsToSelector:@selector(gestureRecognizer:lengthForCommitEditingRowAtIndexPath:)]) {
            commitEditingLength = [self.delegate gestureRecognizer:self lengthForCommitEditingRowAtIndexPath:indexPath];
        }
        if (fabsf(translation.x) >= commitEditingLength) {
            if ([self.delegate respondsToSelector:@selector(gestureRecognizer:commitEditingState:forRowAtIndexPath:)]) {
                [self.delegate gestureRecognizer:self commitEditingState:self.addingCellState forRowAtIndexPath:indexPath];
            }
        } else {
            [UIView beginAnimations:@"" context:nil];
            cell.contentView.frame = cell.contentView.bounds;
            [UIView commitAnimations];
        }
        
        self.addingCellState = TableViewCellEditingStateMiddle;
        self.state = TableViewGestureRecognizerStateNone;
    }
}

#pragma mark UIGestureRecognizer

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.panRecognizer) {
        if ( ! [self.delegate conformsToProtocol:@protocol(TableViewGestureEditingRowDelegate)]) {
            return NO;
        }
        
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        
        CGPoint point = [pan translationInView:self.tableView];
        CGPoint location = [pan locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        
        // The pan gesture recognizer will fail the original scrollView scroll
        // gesture, we wants to ensure we are panning left/right to enable the
        // pan gesture.
        if (fabsf(point.y) > fabsf(point.x)) {
            return NO;
        } else if (indexPath == nil) {
            return NO;
        } else if (indexPath) {
            BOOL canEditRow = [self.delegate gestureRecognizer:self canEditRowAtIndexPath:indexPath];
            return canEditRow;
        }
    } else if (gestureRecognizer == self.pinchRecognizer) {
        if ( ! [self.delegate conformsToProtocol:@protocol(TableViewGestureAddingRowDelegate)]) {
            NSLog(@"Should not begin pinch");
            return NO;
        }
        
        CGPoint location1 = [gestureRecognizer locationOfTouch:0 inView:self.tableView];
        CGPoint location2 = [gestureRecognizer locationOfTouch:1 inView:self.tableView];
        
        CGRect  rect = (CGRect){location1, location2.x - location1.x, location2.y - location1.y};
        NSArray *indexPaths = [self.tableView indexPathsForRowsInRect:rect];
        
        // #16 Crash on pinch fix
        if ([indexPaths count] < 2) {
            NSLog(@"Should not begin pinch");
            return NO;
        }
        
        NSIndexPath *firstIndexPath = [indexPaths objectAtIndex:0];
        NSIndexPath *lastIndexPath  = [indexPaths lastObject];
        NSInteger    midIndex = ((float)(firstIndexPath.row + lastIndexPath.row) / 2) + 0.5;
        NSIndexPath *midIndexPath = [NSIndexPath indexPathForRow:midIndex inSection:firstIndexPath.section];
        
        if ([self.delegate respondsToSelector:@selector(gestureRecognizer:willCreateCellAtIndexPath:)]) {
            self.addingIndexPath = [self.delegate gestureRecognizer:self willCreateCellAtIndexPath:midIndexPath];
        } else {
            self.addingIndexPath = midIndexPath;
        }
        
        if ( ! self.addingIndexPath) {
            NSLog(@"Should not begin pinch");
            return NO;
        }
        
    }
    return YES;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.addingIndexPath]
        && (self.state == TableViewGestureRecognizerStatePinching || self.state == TableViewGestureRecognizerStateDragging)) {
        // While state is in pinching or dragging mode, we intercept the row height
        // For Moving state, we leave our real delegate to determine the actual height
        return MAX(1, self.addingRowHeight);
    }
    
    CGFloat normalCellHeight = aTableView.rowHeight;
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        normalCellHeight = [self.tableViewDelegate tableView:aTableView heightForRowAtIndexPath:indexPath];
    }
    return normalCellHeight;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ( ! [self.delegate conformsToProtocol:@protocol(TableViewGestureAddingRowDelegate)]) {
        if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
            [self.tableViewDelegate scrollViewDidScroll:scrollView];
        }
        return;
    }
    
    // We try to create a new cell when the user tries to drag the content to and offset of negative value
    if (scrollView.contentOffset.y < 0) {
        // Here we make sure we're not conflicting with the pinch event,
        // ! scrollView.isDecelerating is to detect if user is actually
        // touching on our scrollView, if not, we should assume the scrollView
        // needed not to be adding cell
        if ( ! self.addingIndexPath && self.state == TableViewGestureRecognizerStateNone && ! scrollView.isDecelerating) {
            self.state = TableViewGestureRecognizerStateDragging;
            
            self.addingIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            if ([self.delegate respondsToSelector:@selector(gestureRecognizer:willCreateCellAtIndexPath:)]) {
                self.addingIndexPath = [self.delegate gestureRecognizer:self willCreateCellAtIndexPath:self.addingIndexPath];
            }
            
            if (self.addingIndexPath) {
                [self.tableView beginUpdates];
                [self.delegate gestureRecognizer:self needsAddRowAtIndexPath:self.addingIndexPath];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:self.addingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                self.addingRowHeight = fabsf(scrollView.contentOffset.y);
                [self.tableView endUpdates];
            }
        }
    }
    
    // Check if addingIndexPath not exists, we don't want to
    // alter the contentOffset of our scrollView
    if (self.addingIndexPath && self.state == TableViewGestureRecognizerStateDragging) {
        self.addingRowHeight += scrollView.contentOffset.y * -1;
        [self.tableView reloadData];
        [scrollView setContentOffset:CGPointZero];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ( ! [self.delegate conformsToProtocol:@protocol(TableViewGestureAddingRowDelegate)]) {
        if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
            [self.tableViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
        }
        return;
    }
    
    if (self.state == TableViewGestureRecognizerStateDragging) {
        self.state = TableViewGestureRecognizerStateNone;
        [self commitOrDiscardCell];
    }
}

#pragma mark NSProxy

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.tableViewDelegate];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [(NSObject *)self.tableViewDelegate methodSignatureForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    NSAssert(self.tableViewDelegate != nil, @"self.tableViewDelegate should not be nil, assign your tableView.delegate before enabling gestureRecognizer", nil);
    if ([self.tableViewDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [[self class] instancesRespondToSelector:aSelector];
}

#pragma mark Class method

+ (TableViewGestureRecognizer *)gestureRecognizerWithTableView:(UITableView *)tableView delegate:(id)delegate {
    TableViewGestureRecognizer *recognizer = [[TableViewGestureRecognizer alloc] init];
    recognizer.delegate             = (id)delegate;
    recognizer.tableView            = tableView;
    recognizer.tableViewDelegate    = tableView.delegate;     // Assign the delegate before chaning the tableView's delegate
    tableView.delegate              = recognizer;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:recognizer action:@selector(pinchGestureRecognizer:)];
    [tableView addGestureRecognizer:pinch];
    pinch.delegate             = recognizer;
    recognizer.pinchRecognizer = pinch;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:recognizer action:@selector(panGestureRecognizer:)];
    [tableView addGestureRecognizer:pan];
    pan.delegate             = recognizer;
    recognizer.panRecognizer = pan;
    
    return recognizer;
}

@end


@implementation UITableView (TableViewGestureDelegate)

- (TableViewGestureRecognizer *)enableGestureTableViewWithDelegate:(id)delegate {
    if ( ! [delegate conformsToProtocol:@protocol(TableViewGestureAddingRowDelegate)]
        && ! [delegate conformsToProtocol:@protocol(TableViewGestureEditingRowDelegate)]){
        [NSException raise:@"delegate should at least conform to one of TableViewGestureAddingRowDelegate, TableViewGestureEditingRowDelegate or TableViewGestureMoveRowDelegate" format:nil];
    }
    TableViewGestureRecognizer *recognizer = [TableViewGestureRecognizer gestureRecognizerWithTableView:self delegate:delegate];
    return recognizer;
}

#pragma mark Helper methods

- (void)reloadVisibleRowsExceptIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *visibleRows = [[self indexPathsForVisibleRows] mutableCopy];
    [visibleRows removeObject:indexPath];
    [self reloadRowsAtIndexPaths:visibleRows withRowAnimation:UITableViewRowAnimationNone];
}

@end
