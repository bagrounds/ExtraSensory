//
//  ES_Scheduler.h
//  ExtraSensory
//
//  Created by Bryan Grounds on 10/1/13.
//  Copyright (c) 2013 Bryan Grounds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ES_HomeViewController, ES_User, ES_Activity;

@interface ES_Scheduler : NSObject

@property (nonatomic, weak) ES_User* user;

- (BOOL) isPeriodicRecordingMechanismOn;
- (void) sampleSaveSendCycler;
- (void) turnOffRecording;
- (void) activeFeedback: (ES_Activity *) activity;

- (void) turnOffNaggingMechanism;
- (void) setTimerForNaggingCheckup;

@end
