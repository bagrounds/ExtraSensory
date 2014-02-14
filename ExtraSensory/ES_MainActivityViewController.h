//
//  ES_MainActivityViewController.h
//  ExtraSensory
//
//  Created by Kat Ellis on 2/10/14.
//  Copyright (c) 2014 Bryan Grounds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ES_Activity.h"

@interface ES_MainActivityViewController : UITableViewController

@property ES_Activity *activity;
@property NSArray *choices;

@end
