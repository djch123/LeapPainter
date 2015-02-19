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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leapStateChanged" object:@"running"];
}


#pragma mark - SampleListener Callbacks

- (void)onInit:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leapStateChanged" object:@"Initialized"];
}

- (void)onConnect:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leapStateChanged" object:@"Connected"];
    LeapController *aController = (LeapController *)[notification object];
    [aController enableGesture:LEAP_GESTURE_TYPE_CIRCLE enable:YES];
}

- (void)onDisconnect:(NSNotification *)notification
{
    //Note: not dispatched when running in a debugger.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leapStateChanged" object:@"Disconnected"];
}

- (void)onServiceConnect:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leapStateChanged" object:@"Service Connected"];
}

- (void)onServiceDisconnect:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leapStateChanged" object:@"Service Disconnected"];
}

- (void)onDeviceChange:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leapStateChanged" object:@"Device Changed"];
}

- (void)onExit:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leapStateChanged" object:@"Exited"];
}

- (void)onFrame:(NSNotification *)notification
{
    LeapController *aController = (LeapController *)[notification object];
    
    // Get the most recent frame and report some basic information
    LeapFrame *frame = [aController frame:0];
    LeapInteractionBox *iBox = frame.interactionBox;

    // Get hands
    for (LeapHand *hand in frame.hands) {
        if (hand.isLeft) continue;
        
        for (LeapFinger *finger in hand.fingers) {
            if ([[fingerNames objectAtIndex:finger.type]  isEqual: @"Index finger"]){
                LeapVector *leapPoint = [finger bone:LEAP_BONE_TYPE_DISTAL].nextJoint;
                
                LeapVector *normalizedPoint = [iBox normalizePoint:leapPoint clamp:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"leapPositionChanged" object:normalizedPoint];
            }
        }
    }
    
    NSArray *gestures = [frame gestures:nil];
    for (int g = 0; g < [gestures count]; g++) {
        LeapGesture *gesture = [gestures objectAtIndex:g];
        switch (gesture.type) {
            case LEAP_GESTURE_TYPE_CIRCLE: {
                LeapCircleGesture *circleGesture = (LeapCircleGesture *)gesture;
                LeapVector *center = [circleGesture center];
                LeapVector *normalizedCenter = [iBox normalizePoint:center clamp:YES];
                NSMutableArray *message;
                message = [[NSMutableArray alloc] init];
                [message addObject:gesture];
                [message addObject:normalizedCenter];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"leapCircleGesture" object:message];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leapStateChanged" object:@"Focus Gained"];
}

- (void)onFocusLost:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leapStateChanged" object:@"Focus Lost"];
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
