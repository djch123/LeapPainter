//
//  MasterViewController.m
//  LPainter
//
//  Created by Jessie Gao on 2/17/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import "MasterViewController.h"
#import "LeapData.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void) awakeFromNib{
    [self getAllViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leapPositionChanged:) name:@"leapPositionChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leapCircleGesture:) name:@"leapCircleGesture" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void) getAllViews {
    for ( NSView* subView in [self.view subviews]){
        if ([subView isKindOfClass:[PaperView class]]){
            paperView = (PaperView*)subView;
        }
    }
}

- (void) leapPositionChanged:(NSNotification*) notification{
    NSLog(@"position changed");
}

- (void) leapCircleGesture:(NSNotification*) notification{
    NSLog(@"circle");
}

@end
