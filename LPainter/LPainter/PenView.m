//
//  PenView.m
//  LPainter
//
//  Created by Jessie Gao on 2/18/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import "PenView.h"
#import "MasterViewController.h"

@implementation PenView

- (id)initWithFrame:(NSRect)frameRect{
    if(self=[super initWithFrame:frameRect]){
        [self awakeFromNib];
    }
    return self;
}

-(void) awakeFromNib{
    nowColor = [NSColor DEFAULT_COLOR];
    nowWidth = [NSNumber numberWithFloat:DEFAULT_LINE_WIDTH];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSBezierPath *path;
    path = [NSBezierPath bezierPath];
    
    NSPoint center;
    center.x = [self bounds].size.width/2;
    center.y = [self bounds].size.height/2;
    
    [nowColor set];
    [path appendBezierPathWithArcWithCenter:center radius:[nowWidth floatValue]/2 startAngle:0 endAngle:360];
    [path fill];
    [path stroke];
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
