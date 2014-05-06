//
//  MPSMapViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 4/20/14.
//
//

#import "MPSMapViewController.h"
#import "MPSPrinterViewController.h"
#import "MPSListNavController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    double posLat  = self.locationManager.location.coordinate.latitude;
    double posLong = self.locationManager.location.coordinate.longitude;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:posLat
                                                            longitude:posLong
                                                                 zoom:18];
    
    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:camera];
    [self.mapView moveCamera:update];
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    
    for (MPSPrinter *printer in self.printers)
    {
        double currLong = printer.longitude;
        double currLat = printer.latitude;
        
        NSString *currName = printer.building;
        NSString *currSnippet =  printer.room;
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(currLat, currLong);
        
        marker.title = currName;
        marker.snippet = currSnippet;
        marker.map = self.mapView;
        marker.userData = printer;
    }
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    double posLat = self.locationManager.location.coordinate.latitude;
    double posLong = self.locationManager.location.coordinate.longitude;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:posLat
                                                            longitude:posLong
                                                                 zoom:18];
    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:camera];
    [self.mapView moveCamera:update];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker*)marker {
    [self performSegueWithIdentifier:@"MapSegue" sender:marker];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    GMSMarker *marker = sender;

    MPSPrinterViewController *detailController = segue.destinationViewController;
    MPSPrinter *printer = marker.userData;
    detailController.printer = printer;
    detailController.title = [printer name];
}


@end
