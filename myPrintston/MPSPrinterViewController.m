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
#import "MPSMapAnnotation.h"
#import <GoogleMaps/GoogleMaps.h>

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
    CLLocationManager *locMgr = self.locationManager;
    double userLat = locMgr.location.coordinate.latitude;
    double userLong = locMgr.location.coordinate.longitude;
    
    // center on user
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:userLat
                                                            longitude:userLong
                                                                 zoom:18];
    
    // setup
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // user location
    GMSMarker *userLoc = [[GMSMarker alloc] init];
    userLoc.position = CLLocationCoordinate2DMake(userLat, userLong);
    
    userLoc.map = mapView_;
    
    // get current printer location / add marker
    MPSPrinter *printer = self.printer;
    
    double currLong = printer.longitude;
    double currLat = printer.latitude;
    
    NSString *currName = printer.building;
    NSString *currSnippet =  printer.room;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(currLat, currLong);
    
    marker.title = currName;
    marker.snippet = currSnippet;
    marker.map = mapView_;
    
    
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

@end
