//
//  AppDelegate.m
//  LPainter
//
//  Created by Jessie Gao on 2/17/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "LeapData.h"

@interface AppDelegate ()

@property (nonatomic, strong, readwrite)IBOutlet NSWindow *window;
@property (nonatomic,strong) IBOutlet MasterViewController *masterViewController;

@end

@implementation AppDelegate

@synthesize leapData = _leapData;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    // 1. Create the master View Controller
    self.masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    
    // 2. Add the view controller to the Window's content view
    [self.window.contentView addSubview:self.masterViewController.view];
    self.masterViewController.view.frame = ((NSView*)self.window.contentView).bounds;
    
    _leapData = [[LeapData alloc] init];
    [_leapData run];    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)savePainting:(id)sender {
    [self.masterViewController savePaperView];
}

- (BOOL)windowShouldClose:(id)sender
{
    [self.masterViewController askSaveOrNot];
    return YES;
}

@end
