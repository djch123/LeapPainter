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
    [path2 appendBezierPathWithArcWithCenter:center radius:[nowWidth floatValue]/2+.5 startAngle:0 endAngle:360];
    [path2 stroke];
    
    NSBezierPath *path3;  // huge gray circle with unfixed size
    path3 = [NSBezierPath bezierPath];
    
    if ([mouse z]<.5) [[NSColor grayColor] set];
    else [[NSColor blackColor] set];
    [path3 appendBezierPathWithArcWithCenter:center radius:[self getHugeCircleRadius] startAngle:0 endAngle:360];
    [path3 stroke];
}

- (void) leapMouseMoved:(LeapVector*) position{
    mouse = position;
    
    // alpha
    CGFloat alpha;
    CGFloat z;
    
    z = [mouse z];
    if (z<=.5) alpha = 1;
    else alpha = 1 - (z-.5)*1.3;
    
    nowColor = [nowColor colorWithAlphaComponent:alpha];
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

- (CGFloat) getHugeCircleRadius {
    CGFloat z;
    z = [mouse z];
    if (z<=.5 && [[nowColor colorUsingColorSpaceName:
          NSCalibratedWhiteColorSpace] whiteComponent] == 1.0) return [nowWidth floatValue]/2 + 1;
    
    if (z<=0.5) return [nowWidth floatValue]/2 + 1 + (-z+.5)*3*[nowWidth floatValue];
    return [nowWidth floatValue]/2 + 1 + (z-.5)*3*[nowWidth floatValue];
}
@end
