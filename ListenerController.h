//
//  BlowInputController.h
//  iBalloon
//
//  Created by Corey Floyd on 7/16/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCListener;


@protocol ListenerControllerDelegate

- (void)didUpdateAveragePower:(float)averagePower;

@end



@interface ListenerController : NSObject {
    
    SCListener *myListener;
    NSTimer *refreshTimer;
    
    float refreshTimerInterval;
    
    float currentAveragePower;
    float peakPower;
    
    id<ListenerControllerDelegate> delegate;

}
@property(nonatomic,retain)SCListener *myListener;
@property(nonatomic,retain)NSTimer *refreshTimer;
@property(nonatomic,assign)float refreshTimerInterval;
@property(nonatomic,assign)float currentAveragePower;
@property(nonatomic,assign)float peakPower;
@property(nonatomic,assign)id<ListenerControllerDelegate> delegate;


- (void)beginMonitoringAudio;
- (void)endMonitoringAudio;
- (void)pauseMonitoringAudio;
- (void)resumeMonitoringAudio;

@end
