//
//  PaperView.m
//  LPainter
//
//  Created by Jessie Gao on 2/17/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import "PaperView.h"
#import "MasterViewController.h"

@implementation PaperView
- (id)initWithFrame:(NSRect)frameRect{
    if(self=[super initWithFrame:frameRect]){
        [self awakeFromNib];
    }
    return self;
}

-(void) awakeFromNib{
    lines = [[NSMutableArray alloc] init];
    nowColor = [NSColor DEFAULT_COLOR];
    nowWidth = [NSNumber numberWithFloat:DEFAULT_LINE_WIDTH];
    lastPosition = nil;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    NSColor *c;
    NSNumber *w;
    LeapVector *p;
    LeapVector *n;
    NSPoint pre;
    NSPoint cur;
    
    for (int i=3; i<[lines count]; i+=4){
        c = [lines objectAtIndex:i-3];
        w = [lines objectAtIndex:i-2];
        p = [lines objectAtIndex:i-1];
        n = [lines objectAtIndex:i];
        
        pre.x = [p x];
        pre.y = [p y];
        cur.x = [n x];
        cur.y = [n y];
        
        [c set];
        
        NSBezierPath *path;
        path = [NSBezierPath bezierPath];
        
        [path setLineCapStyle:NSRoundLineCapStyle];
        [path setLineJoinStyle:NSRoundLineJoinStyle];
        [path setLineWidth:[w floatValue]];
        
        [path moveToPoint:pre];
        [path lineToPoint:cur];
        [path stroke];
    }
}

- (void) addPoint:(LeapVector*) position {
    if ( position == nil ){
        lastPosition = nil;
    }
    else{
        if (lastPosition == nil){
            lastPosition = position;
        }
        else{
            [lines addObject:nowColor];
            [lines addObject:nowWidth];
            [lines addObject:lastPosition];
            [lines addObject:position];
            
            lastPosition = position;
            
            [self setNeedsDisplay:YES];
        }
    }
}

- (void) colorChanged:(NSColor*) color {
    nowColor = color;
    [self setNeedsDisplay:YES];
}

- (void) widthChanged:(NSNumber*) width {
    nowWidth = width;
    [self setNeedsDisplay:YES];
}

@end
