//
//  LeapData.m
//  LPainter
//
//  Created by Jessie Gao on 2/17/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import "LeapData.h"

@implementation LeapData
{
    LeapController *controller;
    NSArray *fingerNames;
    NSArray *boneNames;
}

- (id)init
{
    self = [super init];
    static const NSString *const fingerNamesInit[] = {
        @"Thumb", @"Index finger", @"Middle finger",
        @"Ring finger", @"Little finger"
    };
    static const NSString *const boneNamesInit[] = {
        @"Metacarpal", @"Proximal phalanx",
        @"Intermediate phalanx", @"Distal phalanx"
    };
    fingerNames = [[NSArray alloc] initWithObjects:fingerNamesInit count:5];
    boneNames = [[NSArray alloc] initWithObjects:boneNamesInit count:4];
    return self;
}

- (void)run
{
    controller = [[LeapController alloc] init];
    [controller addListener:self];
    NSLog(@"running");
}


#pragma mark - SampleListener Callbacks

- (void)onInit:(NSNotification *)notification
{
    NSLog(@"Initialized");
}

- (void)onConnect:(NSNotification *)notification
{
    NSLog(@"Connected");
    LeapController *aController = (LeapController *)[notification object];
    [aController enableGesture:LEAP_GESTURE_TYPE_CIRCLE enable:YES];
}

- (void)onDisconnect:(NSNotification *)notification
{
    //Note: not dispatched when running in a debugger.
    NSLog(@"Disconnected");
}

- (void)onServiceConnect:(NSNotification *)notification
{
    NSLog(@"Service Connected");
}

- (void)onServiceDisconnect:(NSNotification *)notification
{
    NSLog(@"Service Disconnected");
}

- (void)onDeviceChange:(NSNotification *)notification
{
    NSLog(@"Device Changed");
}

- (void)onExit:(NSNotification *)notification
{
    NSLog(@"Exited");
}

- (void)onFrame:(NSNotification *)notification
{
    LeapController *aController = (LeapController *)[notification object];
    
    // Get the most recent frame and report some basic information
    LeapFrame *frame = [aController frame:0];

    // Get hands
    for (LeapHand *hand in frame.hands) {
        if (hand.isLeft) continue;
        
        for (LeapFinger *finger in hand.fingers) {
            if ([[fingerNames objectAtIndex:finger.type]  isEqual: @"Index finger"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"leapPositionChanged" object:[finger bone:LEAP_BONE_TYPE_DISTAL].nextJoint];
            }
        }
    }
    
    NSArray *gestures = [frame gestures:nil];
    for (int g = 0; g < [gestures count]; g++) {
        LeapGesture *gesture = [gestures objectAtIndex:g];
        switch (gesture.type) {
            case LEAP_GESTURE_TYPE_CIRCLE: {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"leapCircleGesture" object:gesture];
                break;
            }
            default:
                NSLog(@"  Unknown gesture type");
                break;
        }
    }
}

- (void)onFocusGained:(NSNotification *)notification
{
    NSLog(@"Focus Gained");
}

- (void)onFocusLost:(NSNotification *)notification
{
    NSLog(@"Focus Lost");
}

+ (NSString *)stringForState:(LeapGestureState)state
{
    switch (state) {
        case LEAP_GESTURE_STATE_INVALID:
            return @"STATE_INVALID";
        case LEAP_GESTURE_STATE_START:
            return @"STATE_START";
        case LEAP_GESTURE_STATE_UPDATE:
            return @"STATE_UPDATED";
        case LEAP_GESTURE_STATE_STOP:
            return @"STATE_STOP";
        default:
            return @"STATE_INVALID";
    }
}

@end
