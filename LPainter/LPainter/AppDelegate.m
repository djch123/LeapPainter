//
//  AppDelegate.m
//  LPainter
//
//  Created by Jessie Gao on 2/17/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import "AppDelegate.h"
#import "LeapData.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize leapData = _leapData; // must retain for notifications

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _leapData = [[LeapData alloc] init];
    [_leapData run];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
