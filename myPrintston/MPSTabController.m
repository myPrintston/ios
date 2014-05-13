//
//  MPSTabController.m
//  myPrintston
//
//  Created by Michael J Kim on 4/19/14.
//
//

#import "MPSTabController.h"
#import "MPSPrinter.h"

extern NSString *IP;

@interface MPSTabController ()

@end

@implementation MPSTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Initialize the locationManager and printerList. Load and sort information into the
//   printerList.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self getCurrentLocation];
    
    self.printerList = [MPSPrinterList initWithLocationManager:self.locationManager];
    [self.printerList load];
    [self.printerList sort];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// For initially configuring the locationManager
- (void)getCurrentLocation {
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

// Alert user if the user's location could not be retrieved
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

// Every time we update the user's position, we sort and reload the data in the listView.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.printerList sort];
    [[[[[self.childViewControllers objectAtIndex:0] childViewControllers] objectAtIndex:0] tableView] reloadData];
}

@end
