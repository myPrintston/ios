//
//  MPSMapViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 4/20/14.
//
//

#import "MPSMapViewController.h"
#import "MPSPrinterViewController.h"
#import "MPSTabController.h"

extern NSString *IP;

@interface MPSMapViewController ()
    
@end

@implementation MPSMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// Loads data from the TabViewController and sets property for the MapView
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MPSTabController *tabController = (MPSTabController *) self.tabBarController;
    self.printerList = tabController.printerList;
    self.locationManager = tabController.locationManager;
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    
    // Do any additional setup after loading the view.
}

// Every time we come to this view, refocus the zoom where the user is
//   and replant all the markers.
- (void) viewWillAppear:(BOOL)animated {
    [self.printerList update];
    [self.mapView clear];
    
    // Center the camera on the user
    double posLat = self.locationManager.location.coordinate.latitude;
    double posLong = self.locationManager.location.coordinate.longitude;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:posLat
                                                            longitude:posLong
                                                                 zoom:17];
    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:camera];
    [self.mapView moveCamera:update];
    
    // Replant all the markers for each printer
    for (MPSPrinter *printer in self.printerList.printers)
    {
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        if (printer.status == 0)
            marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
        else if (printer.status == 1)
            marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
        else
            marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        
        marker.title    = printer.building;
        marker.snippet  = printer.room;
        marker.userData = printer;
        marker.position = printer.location.coordinate;
        marker.map      = self.mapView;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Segue to the MPSPrinterView if we tap on the printer information in the map.
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker*)marker {
    [self performSegueWithIdentifier:@"MapSegue" sender:marker];
}


#pragma mark - Navigation


// Pass on information to MPSPrinterViewController before we segue to it.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GMSMarker *marker = sender;

    MPSPrinterViewController *detailController = segue.destinationViewController;
    MPSPrinter *printer = marker.userData;
    detailController.printer = printer;
    detailController.locationManager = self.locationManager;
    detailController.title = [printer name];
}


@end
