//
//  BlowInputController.m
//  iBalloon
//
//  Created by Corey Floyd on 7/16/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "ListenerController.h"
#import "SCListener.h"

@implementation ListenerController

static float kDefaultRefreshInterval = 0.25;

@synthesize myListener;
@synthesize refreshTimer;
@synthesize refreshTimerInterval;
@synthesize currentAveragePower;
@synthesize peakPower;
@synthesize delegate;

- (void) dealloc{
    
    [self endMonitoringAudio];
    self.myListener = nil;
    self.refreshTimer = nil;    
    [super dealloc];
}



- (void)updateLevel{
    
    self.currentAveragePower = [myListener averagePower];
    self.peakPower =  [myListener peakPower];   
    
    [delegate didUpdateAveragePower:currentAveragePower];
    
    
}



- (void)beginMonitoringAudio{
    
    
    if(self.myListener==nil)
        self.myListener = [[[SCListener alloc] init] autorelease];
    
    [myListener listen];
    
    if(refreshTimerInterval == 0)
        refreshTimerInterval = kDefaultRefreshInterval;
    
    
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshTimerInterval 
                                                       target:self 
                                                     selector:@selector(updateLevel) 
                                                     userInfo:nil 
                                                      repeats:YES];
    
    
    
    
}



- (void)endMonitoringAudio{
    
    [myListener stop];
    [refreshTimer invalidate];
    self.refreshTimer=nil;
    
    
}
- (void)pauseMonitoringAudio{
    
    [myListener pause];
    
}
- (void)resumeMonitoringAudio{
    
    [myListener listen];
    
}








@end
