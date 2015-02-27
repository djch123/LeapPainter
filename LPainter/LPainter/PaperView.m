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
@synthesize changed;

- (id)initWithFrame:(NSRect)frameRect{
    if(self=[super initWithFrame:frameRect]){
        [self awakeFromNib];
    }
    return self;
}

-(void) awakeFromNib{
    lines = [[NSMutableArray alloc] init];
    removedLines = nil;
    nowColor = [NSColor DEFAULT_COLOR];
    backgroundColor = [NSColor DEFAULT_BACKGROUND_COLOR];
    nowWidth = [NSNumber numberWithFloat:DEFAULT_LINE_WIDTH];
    nowLine = nil;
    changed = NO;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [backgroundColor set];
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
            changed = YES;
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
        changed = YES;
        removedLines = nil;
        
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
    changed = NO;
    
    [self setNeedsDisplay:YES];
}

- (void) undo {
    if ( nowLine == nil ) {
        if ( [lines count] >=3 ) {
            NSMutableArray *l = [lines lastObject];
            [lines removeLastObject];
            NSNumber *w = [lines lastObject];
            [lines removeLastObject];
            NSColor *c = [lines lastObject];
            [lines removeLastObject];
            
            if (removedLines == nil) {
                removedLines = [[NSMutableArray alloc] init];
            }
            [removedLines addObject:c];
            [removedLines addObject:w];
            [removedLines addObject:l];
            
            changed = YES;
        }
    }
    else {
        nowLine = nil;
        changed = YES;
    }
    
    [self setNeedsDisplay:YES];
}

- (void) redo {
    if ([removedLines count] >=3) {
        NSMutableArray *l = [removedLines lastObject];
        [removedLines removeLastObject];
        NSNumber *w = [removedLines lastObject];
        [removedLines removeLastObject];
        NSColor *c = [removedLines lastObject];
        [removedLines removeLastObject];
        
        [lines addObject:c];
        [lines addObject:w];
        [lines addObject:l];
        
        changed = YES;
    }
    
    [self setNeedsDisplay:YES];
}

- (void) savePainting {
    NSSavePanel *savePanel;
    NSArray *fileTypes;
    NSString *defaultName;
    long rand;
    
    srandom((unsigned int)time(NULL));
    rand = ((double) random())/RAND_MAX *99999999;
    defaultName = [[NSString alloc] initWithFormat:DEFAULT_SAVE_NAME_MODULE, rand];
    fileTypes = [[NSArray alloc] initWithObjects:@"jpeg", @"png", nil];
    savePanel = [[NSSavePanel alloc] init];
    [savePanel setAllowedFileTypes:fileTypes];
    [savePanel setNameFieldStringValue:defaultName];
    
    if ( [savePanel runModal] == NSModalResponseOK ) {
        [self lockFocus];
        NSBitmapImageRep* rep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
        [self cacheDisplayInRect:self.bounds toBitmapImageRep:rep];
        [self unlockFocus];
        
        NSData *data;
        data = [rep representationUsingType:NSJPEGFileType properties:nil];
        [data writeToFile:[[savePanel URL] path] atomically:NO];
        
        changed = NO;
    }
}

- (void) backgroundColorChanged:(NSColor*) color {
    backgroundColor = color;
    [self setNeedsDisplay:YES];
}

@end
