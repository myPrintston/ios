//
//  MPSTabController.m
//  myPrintston
//
//  Created by Michael J Kim on 4/19/14.
//
//

#import "MPSTabController.h"
#import "MPSListNavController.h"
#import "MPSPrinter.h"

@interface MPSTabController () {
    NSMutableArray *printers;
    CLLocationManager *locationManager;
    double userLongitude;
    double userLatitude;
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
    
    userLongitude = -74.6552;
    userLatitude  = 40.345;
    
    locationManager = [[CLLocationManager alloc] init];
    [self getCurrentLocation];
    
    self->printers = self.loadPrinters;
    //[self sortPrinters];
    
    MPSListNavController *controller = self.viewControllers[0];
    controller.printers = self->printers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSMutableArray*) loadPrinters
{
    NSURL *url = [NSURL URLWithString:@"http://54.186.188.121:2016/?pall"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data == nil)
        return [NSMutableArray arrayWithObjects: nil];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray *urlprinters = [[NSMutableArray alloc] init];
    for (NSDictionary *printerInfo in jsonArray) {
        MPSPrinter *printer = [[MPSPrinter alloc] initWithDictionary:printerInfo];
        [urlprinters addObject:printer];
    }
    
    return urlprinters;
}

- (void) sortPrinters
{
    [self->printers sortUsingComparator:^(id p1, id p2) {
        if ([p1 dist2:userLongitude :userLatitude] > [p2 dist2:userLongitude :userLatitude])
            return (NSComparisonResult) NSOrderedDescending;
        else
            return (NSComparisonResult) NSOrderedAscending;
    }];
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
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        userLongitude = currentLocation.coordinate.longitude;
        userLatitude  = currentLocation.coordinate.latitude;
    }
    
    userLongitude = -74.6552;
    userLatitude  = 40.345;
    
    //NSLog(@"Location Update");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}
*/

@end
