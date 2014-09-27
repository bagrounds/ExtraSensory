//
//  ES_SelectionFromListViewController.h
//  ExtraSensory
//
//  Created by yonatan vaizman on 9/8/14.
//  Copyright (c) 2014 Bryan Grounds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ES_SelectionFromListViewController : UITableViewController

@property (nonatomic) BOOL multiSelection; // allow multiple selections
@property NSMutableSet *appliedLabels; // the labels that the user has chosen
@property NSArray *choices; // the possible label choices

@property NSString *category; // Name of the category for which the selection list is presented


@end
