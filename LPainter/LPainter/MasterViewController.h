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
#define DEFAULT_COLOR blackColor
#define DEFAULT_BACKGROUND_COLOR whiteColor
#define DEFAULT_MOUSE_ALPHA (.5)
#define DEFAULT_SAVE_NAME_MODULE @"LPainting%08ld.jpeg"

@interface MasterViewController : NSViewController{
    PaperView* paperView;
    NSMutableArray* colorViews;
    PenView* penView;
    MouseView* mouseView;
    NSNumber* nowWidth;
    NSAlert *alert;
}

- (void) getAllViews;
- (void) leapPositionChanged:(NSNotification*) notification;
- (void) leapCircleGesture:(NSNotification*) notification;
- (NSNumber*) getNewWidth:(NSNumber*) delta_width;
- (void) savePaperView;
- (void) leapDisconnected;
- (void) leapConnected;
- (void) askSaveOrNot;
- (void) clearPaper;
- (void) undoPaper;
- (void) redoPaper;

@end
