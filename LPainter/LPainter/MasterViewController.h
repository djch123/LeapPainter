//
//  MasterViewController.h
//  LPainter
//
//  Created by Jessie Gao on 2/17/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PaperView.h"
#import "PenView.h"
#import "MouseView.h"
#import "StateTextField.h"

#define MAX_CIRCLE_RADIUS (11)
#define DEFAULT_LINE_WIDTH (5)
#define MIN_LINE_WIDTH (2)
#define MAX_LINE_WIDTH (38)
#define PROGRESS_TO_WIDTH_CONSTANT (.02)
#define DEFAULT_COLOR blackColor
#define DEFAULT_MOUSE_ALPHA (.5)

@interface MasterViewController : NSViewController{
    PaperView* paperView;
    NSMutableArray* colorViews;
    PenView* penView;
    MouseView* mouseView;
    StateTextField* stateText;
    NSNumber* nowWidth;
}

- (void) getAllViews;
- (void) leapPositionChanged:(NSNotification*) notification;
- (void) leapCircleGesture:(NSNotification*) notification;
- (void) leapStateChanged:(NSNotification*) notification;
- (NSNumber*) getNewWidth:(NSNumber*) delta_width;

@end
