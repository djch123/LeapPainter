//
//  ColorWellView.m
//  LPainter
//
//  Created by Jessie Gao on 2/27/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import "ColorWellView.h"

@implementation ColorWellView

- (id)initWithFrame:(NSRect)frameRect{
    if(self=[super initWithFrame:frameRect]){
        [self awakeFromNib];
    }
    return self;
}

-(void) awakeFromNib{
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
