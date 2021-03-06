//
//  AppDelegate.h
//  LPainter
//
//  Created by Jessie Gao on 2/17/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LeapData;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong, readwrite)LeapData* leapData;

- (IBAction)savePainting:(id)sender;
- (IBAction)newPainting:(id)sender;
- (IBAction)undoPainting:(id)sender;
- (IBAction)redoPainting:(id)sender;

@end

