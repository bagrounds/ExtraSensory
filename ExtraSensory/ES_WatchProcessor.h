//
//  ES_WatchProcessor.h
//  ExtraSensory
//
//  Created by Rafael Aguayo on 4/29/15.
//  Copyright (c) 2015 Bryan Grounds. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <PebbleKit/PebbleKit.h>
#import "ES_AppDelegate.h"
#import "ES_SensorManager.h"

@interface ES_WatchProcessor : NSObject

@property (nonatomic, strong) NSMutableArray *watchAccTimestamps;
@property (nonatomic, strong) NSMutableArray *mutableWatchAccX;
@property (nonatomic, strong) NSMutableArray *mutableWatchAccY;
@property (nonatomic, strong) NSMutableArray *mutableWatchAccZ;
@property (nonatomic, strong) NSMutableArray *compassTimestamps;
@property (nonatomic, strong) NSMutableArray *compassHeadings;

-(void)receiveDataFromWatch;
-(void)launchWatchApp;
-(void)closeWatchApp;
-(void)stopWatchCollection;
-(void)nagUserWithQuestion: (NSDictionary*)question;
-(void)setUserInfo: (NSMutableDictionary*) userInfo;
-(void)registerReceiveHandler;
-(BOOL)isConnectedToWatch;

@end
