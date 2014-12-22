//
//  ES_HomeViewController.m
//  ExtraSensory
//
//  Created by Bryan Grounds on 9/29/13.
//  Copyright (c) 2013 Bryan Grounds. All rights reserved.
//

#import "ES_HomeViewController.h"
#import "ES_SensorManager.h"
#import "ES_AppDelegate.h"
#import "ES_DataBaseAccessor.h"
#import "ES_Scheduler.h"
#import "ES_User.h"
#import "ES_Settings.h"
#import "ES_ActivityStatistic.h"
#import "ES_FeedbackViewController.h"

@interface ES_HomeViewController ()

@property (strong, nonatomic) IBOutlet UILabel *mostRecentActivityLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mostRecentActivityImage;
@property (weak, nonatomic) IBOutlet UILabel *networkStackSizeLabel;

@property NSMutableArray *activityCountArray;

@end

@implementation ES_HomeViewController

@synthesize settings = _settings;

#define RECORDING_TEXT @"ON"
#define NOT_RECORDING_TEXT @"OFF"


- (ES_AppDelegate *)appDelegate
{
    ES_AppDelegate *appDelegate = (ES_AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

- (void) viewDidAppear:(BOOL)animated
{
    [ES_DataBaseAccessor save];
}

-(void) viewWillAppear:(BOOL)animated
{
    ES_Activity *mostRecentActivity = [ES_DataBaseAccessor getMostRecentActivity];
    [self updateMostRecentActivity:mostRecentActivity];
    
    // Register to listen to activity-change notifications:
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"Activities" object:nil];
    
    // Current storage state:
    [self updateCurrentStorageLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentStorageLabel) name:@"NetworkStackSize" object:[self appDelegate]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ES_DataBaseAccessor save];
    
}

- (void) updateMostRecentActivity:(ES_Activity*) activity;
{
    NSString *activityLabel;
    NSString *dateString;
    if (activity)
    {
        // get time & label from activity object
        
        NSTimeInterval time = (NSTimeInterval)[activity.timestamp doubleValue];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"hh:mm a"];
        dateString = [NSString stringWithFormat: @"%@", [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970: time]]];
        
        if (activity.userCorrection)
        {
            activityLabel = activity.userCorrection;
        } else
        {
            activityLabel = activity.serverPrediction;
        }
        
        if ([activityLabel isEqualToString:@"none"] || [activityLabel isEqualToString:@"don't remember"])
        {
            activityLabel = nil;
        }
        NSLog(@"[homeView] Drawing latest activity: %@ from time: %@",activityLabel,dateString);
    }
    // change the image & label
    if (activityLabel)
    {
        self.mostRecentActivityImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", activityLabel]];
        if (activity.userCorrection)
        {
            self.mostRecentActivityLabel.text = activityLabel;
        }
        else
        {
            // Then the activity label is a guess.
            self.mostRecentActivityLabel.text = [NSString stringWithFormat:@"%@?",activityLabel];
        }
    }
    else
    {
        self.mostRecentActivityImage.image = [UIImage imageNamed:@"house.png"];
        self.mostRecentActivityLabel.text = [NSString new];
    }
    
}

- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    
//    NSLog(@"========== observer change: %@",change);
//    if ([keyPath isEqual:@"mostRecentActivity"]) {
//        ES_Activity* changedActivity = [change objectForKey:NSKeyValueChangeNewKey];
//        [self updateMostRecentActivity:changedActivity];
//    }
}

- (NSString *) timeString: (int) index
{
    ES_AppDelegate *appDelegate = [self appDelegate];
    self.activityCountArray = appDelegate.countLySiStWaRuBiDr;
    
    NSNumber *time = appDelegate.user.settings.timeBetweenSampling;
    NSNumber *numPredictions;
    NSLog(@"numPredictions = %@", numPredictions = [appDelegate.countLySiStWaRuBiDr objectAtIndex:index]);
    time = [NSNumber numberWithDouble: ([time doubleValue] * [numPredictions doubleValue])];
    
    time = [NSNumber numberWithDouble:([time doubleValue] / 60.0)];
    
    NSString *result = [NSString stringWithFormat:@"%@", time];
    return result;
}

- (ES_SensorManager *)sensorManager
{
    ES_AppDelegate *appDelegate = [self appDelegate];
    return appDelegate.sensorManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ES_AppDelegate *appDelegate = [self appDelegate];
    [appDelegate addObserver:self
                  forKeyPath:@"mostRecentActivity"
                     options:NSKeyValueObservingOptionNew
                     context:NULL];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ActivitiesButton"])
    {
        ES_AppDelegate *appDelegate = [self appDelegate];
        [segue.destinationViewController setPredictions: appDelegate.predictions];
        NSLog(@"AppD predictions: %@", appDelegate.predictions );
    }
}


- (void) updateCurrentStorageLabel
{
    NSString *storageString = @"";
    unsigned long storage = [self appDelegate].networkStack.count;
    if (storage > 0)
    {
        NSString *lastWord = (storage == 1) ? @"sample" : @"samples";
        storageString = [NSString stringWithFormat:@"Storing %lu %@.",storage,lastWord];
    }
    self.networkStackSizeLabel.text = storageString;
}

//- (IBAction)ActiveFeedback:(UIButton *)sender {
//    NSLog(@"[home] Active feedback button pressed");
//    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"ActiveFeedback" bundle:nil];
//    ES_FeedbackViewController *feedback = [storyboard instantiateInitialViewController];
//    feedback.feedbackType = ES_FeedbackTypeActive;
//    feedback.modalPresentationStyle = UIModalPresentationFormSheet;
////    [self.navigationController pushViewController:feedback animated:YES];
//    [self presentViewController:feedback animated:YES completion:nil];
//}

@end
