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
    NSMutableArray *printers;
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
    
    [MPSPrinter setUserLongitude: -74.6552];
    [MPSPrinter setUserLatitude:   40.345];
    
    locationManager = [[CLLocationManager alloc] init];
    [self getCurrentLocation];
    
    self->printers = self.loadPrinters;
    [self sortPrinters];
    
    
    MPSListNavController *listController = self.viewControllers[0];
    MPSMapNavController  *mapController = self.viewControllers[1];
    
    listController.printers = self->printers;
    mapController.printers = self->printers;
    listController.locationManager = self->locationManager;
    mapController.locationManager = self->locationManager;
    
    UIAlertView *alert;
    NSString *urlstring = [NSString stringWithFormat:@"%@/logout/", IP];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (!data) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Could not connect to the server"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSMutableArray*) loadPrinters
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pall/", IP]];
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

- (void) updatePrinters
{
    NSMutableArray *printerids = [[NSMutableArray alloc] init];
    for (MPSPrinter *printer in printers)
        [printerids addObject:[NSNumber numberWithInt:printer.printerid]];
    
    NSString *urlstring = [[NSString stringWithFormat:@"%@/pids/", IP] stringByAppendingString:[printerids componentsJoinedByString:@"/"]];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil)
        return;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (int i = 0; i < [printerids count]; i++)
    {
        MPSPrinter *printer = [printers objectAtIndex:i];
        printer.status    = [[jsonArray objectAtIndex:i][@"fields"][@"status"] intValue];
        printer.statusMsg = [jsonArray objectAtIndex:i][@"fields"][@"statusMsg"];
    }
}

- (void) sortPrinters
{
    CLLocation *userLocation = locationManager.location;
    [self->printers sortUsingComparator:^(id p1, id p2) {
        if ([p1 distCL:userLocation] > [p2 distCL:userLocation])
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
//    [MPSPrinter incrementUserLongitude];
    [self sortPrinters];
    [[[[[self.childViewControllers objectAtIndex:0] childViewControllers] objectAtIndex:0] tableView] reloadData];
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
