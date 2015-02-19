//
//  MasterViewController.m
//  LPainter
//
//  Created by Jessie Gao on 2/17/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import "MasterViewController.h"
#import "LeapData.h"
#import "ColorView.h"
#import "LeapObjectiveC.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void) awakeFromNib{
    colorViews = [[NSMutableArray alloc] init];
    nowWidth = [NSNumber numberWithFloat:DEFAULT_LINE_WIDTH];
    
    [self getAllViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leapPositionChanged:) name:@"leapPositionChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leapCircleGesture:) name:@"leapCircleGesture" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leapStateChanged:) name:@"leapStateChanged" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void) getAllViews {
    for ( NSView* subView in [self.view subviews]){
        if ([subView isKindOfClass:[PaperView class]]){
            paperView = (PaperView*)subView;
        }
        else if ([subView isKindOfClass:[ColorView class]]){
            [colorViews addObject:subView];
        }
        else if ([subView isKindOfClass:[PenView class]]){
            penView = (PenView*) subView;
        }
        else if ([subView isKindOfClass:[MouseView class]]){            mouseView = (MouseView*) subView;
        }
        else if ([subView isKindOfClass:[StateTextField class]]){
            stateText = (StateTextField*) subView;
        }
    }
}

- (void) leapPositionChanged:(NSNotification*) notification{
    LeapVector *position = notification.object; // normalized coordinate
    if ([position x]<OUT_OF_RANGE_BOUND ||
        [position x]>(1-OUT_OF_RANGE_BOUND) ||
        [position y]<OUT_OF_RANGE_BOUND ||
        [position y]>(1-OUT_OF_RANGE_BOUND) ||
        [position z]<OUT_OF_RANGE_BOUND ||
        [position z]>(1-OUT_OF_RANGE_BOUND)) {
        [mouseView leapMouseMoved:nil];
        [paperView addPoint:nil];
        return;
    }
    
    NSPoint p;
    int appWidth = [[self view] bounds].size.width;
    int appHeight =[[self view] bounds].size.height;
    
    [position setX:position.x * appWidth]; // position in the view
    [position setY:position.y * appHeight];
    
    p.x = [position x];
    p.y = [position y];
    
    // mouseView
    [mouseView leapMouseMoved:position];
    
    p = [self.view convertPoint:p toView:paperView];
    if ( CGRectContainsPoint(paperView.bounds, p) && [position z] <= 0.5 ){
        LeapVector* positionInPaper;
        positionInPaper = [[LeapVector alloc] init];
        
        [positionInPaper setX:p.x];
        [positionInPaper setY:p.y];
        [positionInPaper setZ:[position z]];
        
        [paperView addPoint:positionInPaper];
    }
    else{
        [paperView addPoint:nil];
    }
    
}

- (void) leapCircleGesture:(NSNotification*) notification{
    
    NSMutableArray *message = notification.object;
    LeapGesture *gesture = [message objectAtIndex:0];
    LeapVector *center = [message objectAtIndex:1];
    LeapCircleGesture *circleGesture = (LeapCircleGesture *) gesture;
    
    // process only index finger gesture
    NSArray *pointableList = gesture.pointables;
    if (pointableList != nil) {
        LeapPointable *pointable;
        pointable = [pointableList objectAtIndex:0];
        if (pointable.isFinger) {
            LeapFinger *finger = (LeapFinger *) pointable;
            if (finger.type != 1) {
                // not index finger
                return;
            }
        }
    }
    
    if (circleGesture.radius > MAX_CIRCLE_RADIUS) return;
    
    int appWidth = [[self view] bounds].size.width;
    int appHeight =[[self view] bounds].size.height;
    
    [center setX:center.x * appWidth]; // position in the view
    [center setY:center.y * appHeight];
    
    NSPoint c;
    c.x = [center x];
    c.y = [center y];
    
    // color changes
    for (ColorView *colorView in colorViews){
        NSPoint point;
        point = [self.view convertPoint:c toView:colorView];
        if (CGRectContainsPoint(colorView.bounds, point)){
            NSColor *color = [colorView color];
            
            if ([colorView.identifier isEqualToString:@"white"]) {
                if ([[[circleGesture pointable] direction] angleTo:[circleGesture normal]] > LEAP_PI/2) {
                    [paperView clear];
                    return;
                }
            }
            
            // send new color to penView, MouseView, PaperView
            [penView colorChanged:color];
            [mouseView colorChanged:color];
            [paperView colorChanged:color];
            
            return;
        }
    }
    
    // width changes
    NSPoint point;
    point = [self.view convertPoint:c toView:penView];
    if (CGRectContainsPoint(penView.bounds, point)){
        
        NSNumber *delta_width;
        if ([[[circleGesture pointable] direction] angleTo:[circleGesture normal]] <= LEAP_PI/2) {
            // clockwise
            delta_width = [NSNumber numberWithFloat:circleGesture.progress * PROGRESS_TO_WIDTH_CONSTANT];
        } else {
            // counterclockwise
            delta_width = [NSNumber numberWithFloat:-circleGesture.progress * PROGRESS_TO_WIDTH_CONSTANT];
        }
        nowWidth = [self getNewWidth:delta_width];
        
        [mouseView widthChanged:nowWidth];
        [penView widthChanged:nowWidth];
        [paperView widthChanged:nowWidth];
    }
    
}

- (void) leapStateChanged:(NSNotification*) notification {
    NSString *state = notification.object;
    stateText.stringValue = state;
}

- (NSNumber*) getNewWidth:(NSNumber*) delta_width {
    CGFloat width;
    width = [delta_width floatValue] + [nowWidth floatValue];
    if (width < MIN_LINE_WIDTH) width = MIN_LINE_WIDTH;
    if (width > MAX_LINE_WIDTH) width = MAX_LINE_WIDTH;
    
    return [NSNumber numberWithFloat:width];
}

@end
