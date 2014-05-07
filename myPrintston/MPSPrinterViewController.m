//
//  MPSPrinterViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 4/3/14.
//
//

#import "MPSListNavController.h"
#import "MPSPrinterViewController.h"
#import "MPSErrorViewController.h"
#import "MPSPrinter.h"

extern BOOL isAdmin;
extern NSString *IP;

@interface MPSPrinterViewController ()

@end

// self.printer = printer

@implementation MPSPrinterViewController

GMSMapView *mapView_;

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
    
    // get position
    double userLat = self.locationManager.location.coordinate.latitude;
    double userLong = self.locationManager.location.coordinate.longitude;
    
    // setup
    self.mapView.myLocationEnabled = YES;
    
    // get current printer location / add marker
    MPSPrinter *printer = self.printer;

    double prLat = printer.latitude;
    double prLong = printer.longitude;

    NSString *prName = printer.building;
    NSString *prSnippet =  printer.room;
    
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(prLat, prLong);
    
    marker.title = prName;
    marker.snippet = prSnippet;
    marker.map = self.mapView;
    
    // get map zoom
    CLLocationCoordinate2D myLocation = CLLocationCoordinate2DMake(userLat, userLong);
    CLLocationCoordinate2D prLocation = CLLocationCoordinate2DMake(prLat, prLong);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:prLocation];

    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:10.0f]];

    
    self.statusMsg.text = [NSString stringWithFormat:@"Status: %@", self.printer.statusMsg];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
// Modify the prepareForSegue method by
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MPSErrorViewController *detailController = segue.destinationViewController;
    detailController.printer = self.printer;
    detailController.title = [self.printer name];
}

- (IBAction)fix {
    UIAlertView *alert;
    
    if (!isAdmin) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Please log in as an administrator first."
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/checklogin", IP];
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
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (![jsonArray[0] boolValue]) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Your admin session has timed out. Please log in again."
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        isAdmin = NO;
        return;
    }
    
    urlstring = [NSString stringWithFormat:@"%@/fixprinter/%d", IP, self.printer.printerid];
    url = [NSURL URLWithString:urlstring];
    data = [NSData dataWithContentsOfURL:url];
    
    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    if (![jsonArray[0] boolValue]) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:jsonArray[1]
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
    }
    
    alert = [[UIAlertView alloc]
             initWithTitle:@"Fixed"
             message:jsonArray[1]
             delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
    [alert show];
}

@end
