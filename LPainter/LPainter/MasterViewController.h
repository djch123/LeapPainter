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

#define MAX_CIRCLE_RADIUS (11)
#define DEFAULT_LINE_WIDTH (5)
#define MIN_LINE_WIDTH (2)
#define MAX_LINE_WIDTH (38)
#define PROGRESS_TO_WIDTH_CONSTANT (.02)
#define DEFAULT_MOUSE_ALPHA (.5)
#define CLICK_INTERVAL (1)

#define DEFAULT_COLOR blackColor
#define DEFAULT_BACKGROUND_COLOR whiteColor

#define DEFAULT_SAVE_NAME_MODULE @"LPainting%08ld.jpeg"
#define NEW @"new"
#define REFRESH @"refresh"
#define REDO @"redo"
#define UNDO @"undo"
#define DOWNLOAD @"download"

@interface MasterViewController : NSViewController{
    PaperView* paperView;
    NSMutableArray* colorViews;
    NSMutableArray* iconViews;
    PenView* penView;
    MouseView* mouseView;
    NSNumber* nowWidth;
    NSAlert *alert;
    
    NSDate *timer;
}

- (void) getAllViews;
- (void) leapPositionChanged:(NSNotification*) notification;
- (void) leapCircleGesture:(NSNotification*) notification;
- (NSNumber*) getNewWidth:(NSNumber*) delta_width;
- (void) leapDisconnected;
- (void) leapConnected;
- (void) askSaveOrNot;
- (void) newPaper;
- (void) clearPaper;
- (void) undoPaper;
- (void) redoPaper;
- (void) savePaper;

@end
