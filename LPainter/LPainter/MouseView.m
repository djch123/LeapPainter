//
//  MouseView.m
//  LPainter
//
//  Created by Jessie Gao on 2/18/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import "MouseView.h"
#import "MasterViewController.h"

@implementation MouseView

- (id)initWithFrame:(NSRect)frameRect{
    if(self=[super initWithFrame:frameRect]){
        [self awakeFromNib];
    }
    return self;
}

-(void) awakeFromNib{
    nowColor = [[NSColor DEFAULT_COLOR] colorWithAlphaComponent:DEFAULT_MOUSE_ALPHA];
    nowWidth = [NSNumber numberWithFloat:DEFAULT_LINE_WIDTH];
    mouse = nil;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    if (mouse == nil) return;
    
    NSBezierPath *path1;  // small filled circle
    path1 = [NSBezierPath bezierPath];
    
    NSPoint center;
    center.x = [mouse x];
    center.y = [mouse y];
    
    [nowColor set];
    [path1 appendBezierPathWithArcWithCenter:center radius:[nowWidth floatValue]/2 startAngle:0 endAngle:360];
    [path1 fill];
    [path1 stroke];
    
    NSBezierPath *path2;  // big white circle
    path2 = [NSBezierPath bezierPath];
    
    [[NSColor whiteColor] set];
    [path2 appendBezierPathWithArcWithCenter:center radius:[nowWidth floatValue]/2+1 startAngle:0 endAngle:360];
    [path2 stroke];
}

- (void) leapMouseMoved:(LeapVector*) position{
    mouse = position;
    [self setNeedsDisplay:YES];
}

- (void) colorChanged:(NSColor*) color {
    nowColor = color;
    nowColor = [nowColor colorWithAlphaComponent:DEFAULT_MOUSE_ALPHA];
    [self setNeedsDisplay:YES];
}

- (void) widthChanged:(NSNumber*) width {
    nowWidth = width;
    [self setNeedsDisplay:YES];
}

@end
