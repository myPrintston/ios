//
//  MPSTabController.m
//  myPrintston
//
//  Created by Michael J Kim on 4/19/14.
//
//

#import "MPSTabController.h"
#import "MPSListNavController.h"
#import "MPSMapNavController.h"
#import "MPSPrinter.h"

extern NSString *IP;

@interface MPSTabController () {
    CLLocationManager *locationManager;
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    locationManager = [[CLLocationManager alloc] init];
    [self getCurrentLocation];
    
    self.printerList = [MPSPrinterList initWithLocationManager:locationManager];
    [self.printerList load];
    [self.printerList sort];
    
    MPSListNavController *listController = self.viewControllers[0];
    MPSMapNavController  *mapController = self.viewControllers[1];
    
    listController.printerList = self.printerList;
    mapController.printerList = self.printerList;
    listController.locationManager = self->locationManager;
    mapController.locationManager = self->locationManager;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCurrentLocation {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.printerList sort];
    [[[[[self.childViewControllers objectAtIndex:0] childViewControllers] objectAtIndex:0] tableView] reloadData];
}

@end
