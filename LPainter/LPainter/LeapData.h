//
//  LeapData.h
//  LPainter
//
//  Created by Jessie Gao on 2/17/15.
//  Copyright (c) 2015 jessie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeapObjectiveC.h"

#define LEFT_HAND 1
#define RIGHT_HAND -1
#define NO_HAND 0

@interface LeapData : NSObject<LeapListener> {
    int handState;
}

-(void) run;

@end
