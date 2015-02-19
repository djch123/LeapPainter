//
//  MouseView.h
//  LPainter
//
//  Created by Jessie Gao on 2/18/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LeapObjectiveC.h"

@interface MouseView : NSView{
    NSColor* nowColor;
    NSNumber* nowWidth;
    LeapVector* mouse;
}

- (void) colorChanged:(NSColor*) color;
- (void) widthChanged:(NSNumber*) width;
- (void) leapMouseMoved:(LeapVector*) position;
- (CGFloat) getHugeCircleRadius;

@end
