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
    NSPoint center;
    center.x = [self bounds].size.width/2;
    center.y = [self bounds].size.height/2;
    
    NSBezierPath *path1;
    path1 = [NSBezierPath bezierPath];
    
    [nowColor set];
    [path1 appendBezierPathWithArcWithCenter:center radius:[nowWidth floatValue]/2 startAngle:0 endAngle:360];
    [path1 fill];
    [path1 stroke];
    
    NSBezierPath *path2;
    path2 = [NSBezierPath bezierPath];
    
    [[NSColor grayColor] set];
    [path2 appendBezierPathWithArcWithCenter:center radius:.5+[nowWidth floatValue]/2 startAngle:0 endAngle:360];
    [path2 stroke];
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
