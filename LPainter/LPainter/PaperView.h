//
//  PaperView.h
//  LPainter
//
//  Created by Jessie Gao on 2/17/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LeapObjectiveC.h"

@interface PaperView : NSView{
    NSMutableArray *lines;
    NSMutableArray *nowLine;
    
    NSColor *nowColor;
    NSNumber *nowWidth;
}

- (void) addPoint:(LeapVector*) position;
- (void) colorChanged:(NSColor*) color;
- (void) widthChanged:(NSNumber*) width;

@end
