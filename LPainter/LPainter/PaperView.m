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
    nowLine = nil;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    NSColor *c;
    NSNumber *w;
    NSPoint p;
    
    for (int i=2; i<[lines count]; i+=3){
        c = [lines objectAtIndex:i-2];
        w = [lines objectAtIndex:i-1];
        NSMutableArray *line = [lines objectAtIndex:i];
        
        [c set];
        
        NSBezierPath *path;
        path = [NSBezierPath bezierPath];
        
        [path setLineCapStyle:NSRoundLineCapStyle];
        [path setLineJoinStyle:NSRoundLineJoinStyle];
        [path setLineWidth:[w floatValue]];
        
        p.x = [[line objectAtIndex:0] x];
        p.y = [[line objectAtIndex:0] y];
        [path moveToPoint:p];
        for (int j=1; j<[line count]; ++j){
            p.x = [[line objectAtIndex:j] x];
            p.y = [[line objectAtIndex:j] y];
            
            [path lineToPoint:p];
        }
        [path stroke];
    }
    
    if ([nowLine count]>=2){
        [nowColor set];
        
        NSBezierPath *path;
        path = [NSBezierPath bezierPath];
        
        [path setLineCapStyle:NSRoundLineCapStyle];
        [path setLineJoinStyle:NSRoundLineJoinStyle];
        [path setLineWidth:[nowWidth floatValue]];
        
        p.x = [[nowLine objectAtIndex:0] x];
        p.y = [[nowLine objectAtIndex:0] y];
        [path moveToPoint:p];
        for (int j=1; j<[nowLine count]; ++j){
            p.x = [[nowLine objectAtIndex:j] x];
            p.y = [[nowLine objectAtIndex:j] y];
            
            [path lineToPoint:p];
        }
        [path stroke];

    }
}

- (void) addPoint:(LeapVector*) position {
    if ( position == nil ){
        if ( nowLine != nil && [nowLine count]>=2 ){
            [lines addObject:nowColor];
            [lines addObject:nowWidth];
            [lines addObject:nowLine];

            nowLine = nil;
        }
    }
    else{
        if (nowLine == nil) {
            nowLine = [[NSMutableArray alloc] init];
            [nowLine addObject:position];
        }
        else{
            [nowLine addObject:position];
        }
        [self setNeedsDisplay:YES];
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

- (void) clear {
    [lines removeAllObjects];
    [nowLine removeAllObjects];
    nowLine = nil;
    
    [self setNeedsDisplay:YES];
}

@end
