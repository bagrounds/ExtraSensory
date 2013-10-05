//
//  ES_UserActivityLabel.h
//  ExtraSensory
//
//  Created by Bryan Grounds on 10/4/13.
//  Copyright (c) 2013 Bryan Grounds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ES_Activity;

@interface ES_UserActivityLabel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) ES_Activity *activity;

@end