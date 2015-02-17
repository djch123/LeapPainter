//
//  MasterViewController.h
//  LPainter
//
//  Created by Jessie Gao on 2/17/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PaperView.h"

@interface MasterViewController : NSViewController{
    PaperView* paperView;
}

- (void) getAllViews;
- (void) leapPositionChanged:(NSNotification*) notification;
- (void) leapCircleGesture:(NSNotification*) notification;

@end
