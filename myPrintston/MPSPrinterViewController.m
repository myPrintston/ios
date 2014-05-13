//
//  MPSPrinterViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 4/3/14.
//
//

#import "MPSPrinterViewController.h"
#import "MPSErrorViewController.h"
#import "MPSFixErrorController.h"
#import "MPSPrinter.h"

extern BOOL isAdmin;
extern NSString *IP;

@interface MPSPrinterViewController ()

@end

// self.printer = printer

@implementation MPSPrinterViewController

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
    
    // Set up the MapView
    self.mapView.myLocationEnabled = YES;
    
    // Initialize the marker for the printer and fill the fields
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = self.printer.location.coordinate;
    marker.title = self.printer.building;
    marker.snippet = self.printer.room;
    marker.map = self.mapView;
    
    // Set the color of the marker
    if (self.printer.status == 0)
        marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    else if (self.printer.status == 1)
        marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
    else
        marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    
    // Get the appropriate map zoom
    CLLocationCoordinate2D myLocation = self.locationManager.location.coordinate;
    CLLocationCoordinate2D prLocation = self.printer.location.coordinate;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:prLocation];

    // Zoom in the map
    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:20.0f]];

    
    // Display the status of the printer
    self.statusMsg.text = [NSString stringWithFormat:@"Status: %@", self.printer.statusMsg];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Method that gets called when the user presses the fix button. Only segues to FixErrorView
//   if appropriate. When not, tell user/admin why.
- (IBAction)fix {
    UIAlertView *alert;
    
    // If the printer has nothing to be fixed, tell the user. It's fine to display this
    //   message to non-admins
    if (self.printer.status == 0) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"There is nothing to fix for this printer!"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // If user is not an Admin by the internal tracking method, then tell the user to
    //   log in first.
    if (!isAdmin) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Please log in as an administrator first."
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Check the login status of the admin in case they timed out.
    NSString *urlstring = [NSString stringWithFormat:@"%@/checklogin", IP];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];

    // If no response from the server, tell the admin so.
    if (!data) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Could not connect to the server"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // If the admin timed out of his session, tell the admin so and tell them to log
    //   in again.
    if (![jsonArray[0] boolValue]) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Your admin session has timed out. Please log in again."
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        isAdmin = NO;
        return;
    }
    
    // If user is an admin and an error needs to be fixed, segue to the FixErrorView.
    [self performSegueWithIdentifier:@"FixError" sender:nil];
    return;
}

#pragma mark - Navigation

// Pass on information to either the MPSErrorViewController or the MPSFixErrorController
//   before the segue.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController class] == [MPSErrorViewController class]) {
        MPSErrorViewController *detailController = segue.destinationViewController;
        detailController.printer = self.printer;
        detailController.title = [self.printer name];
    } else {
        MPSFixErrorController *detailController = segue.destinationViewController;
        detailController.printer = self.printer;
        detailController.title = [self.printer name];
    }
}

@end
