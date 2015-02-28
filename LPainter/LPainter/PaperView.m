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
    [lines addObject:[NSColor DEFAULT_BACKGROUND_COLOR]];
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
    
    for (int i=0; i<[lines count]; ++i){
        if ([[lines objectAtIndex:i] isKindOfClass:[NSColor class]]) {
            continue;
        }
        
        NSMutableArray *lineWithProperty = [lines objectAtIndex:i];
        c = [lineWithProperty objectAtIndex:0];
        w = [lineWithProperty objectAtIndex:1];
        NSMutableArray *line = [lineWithProperty objectAtIndex:2];
        
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
            [[NSSound soundNamed:@"Pop"] play];
            
            NSMutableArray *lineWithProperty;
            lineWithProperty = [[NSMutableArray alloc] init];
            [lineWithProperty addObject:nowColor];
            [lineWithProperty addObject:nowWidth];
            [lineWithProperty addObject:nowLine];
            
            [lines addObject:lineWithProperty];

            nowLine = nil;
            changed = YES;
        }
    }
    else{
        if (nowLine == nil) {
            [[NSSound soundNamed:@"Morse"] play];
            
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
    if (![color isEqual:nowColor]) {
        nowColor = color;
        [[NSSound soundNamed:@"Morse"] play];
    }
    [self setNeedsDisplay:YES];
}

- (void) widthChanged:(NSNumber*) width {
    nowWidth = width;
    [self setNeedsDisplay:YES];
}

- (void) clear {
    [[NSSound soundNamed:@"Frog"] play];
    [lines removeAllObjects];
    [lines addObject:[NSColor DEFAULT_BACKGROUND_COLOR]];
    [nowLine removeAllObjects];
    [removedLines removeAllObjects];
    nowLine = nil;
    changed = NO;
    backgroundColor = [NSColor DEFAULT_BACKGROUND_COLOR];
    
    [self setNeedsDisplay:YES];
}

- (void) undo {
    if ( nowLine == nil ) {
        if ( [lines count] >1 ) {
            if ([[lines lastObject] isKindOfClass:[NSColor class]]) {
                for (int i=(int)[lines count]-2; i>=0; --i) {
                    if ([[lines objectAtIndex:i] isKindOfClass:[NSColor class]]) {
                        backgroundColor = [lines objectAtIndex:i];
                        break;
                    }
                }
            }
            if (removedLines == nil) {
                removedLines = [[NSMutableArray alloc] init];
            }
            [removedLines addObject:[lines lastObject]];
            if ([lines count] >1) [lines removeLastObject];
            
            [[NSSound soundNamed:@"Morse"] play];
            changed = YES;
        }
        else {
            [[NSSound soundNamed:@"Funk"] play];
        }
    }
    else {
        nowLine = nil;
        changed = YES;
    }
    
    [self setNeedsDisplay:YES];
}

- (void) redo {
    if ([removedLines count] >0) {
        if ([[removedLines lastObject] isKindOfClass:[NSColor class]]) {
            backgroundColor = [removedLines lastObject];
        }
        
        [lines addObject:[removedLines lastObject]];
        [removedLines removeLastObject];
        
        [[NSSound soundNamed:@"Pop"] play];
        changed = YES;
        
        [self setNeedsDisplay:YES];
    }
    else{
        [[NSSound soundNamed:@"Funk"] play];
    }
}

- (void) savePainting {
    [[NSSound soundNamed:@"Bottle"] play];
    
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
    if (![color isEqual:backgroundColor]) {
        [[NSSound soundNamed:@"Pop"] play];
        backgroundColor = color;
        [lines addObject:backgroundColor];
    }
    [self setNeedsDisplay:YES];
}

@end
