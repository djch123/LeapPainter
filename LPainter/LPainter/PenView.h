//
//  PenView.h
//  LPainter
//
//  Created by Jessie Gao on 2/18/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PenView : NSView{
    NSColor* nowColor;
    NSNumber* nowWidth;
}

- (void) colorChanged:(NSColor*) color;
- (void) widthChanged:(NSNumber*) width;

@end
