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
#import <GoogleMaps/GoogleMaps.h>

@interface MPSMapViewController ()
    
@end

@implementation MPSMapViewController

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
    

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.3457006
                                                            longitude:-74.65758709
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(40.3457006,-74.65758709);
    marker.title = @"Wright Hall";
    marker.snippet = @"3rd Floor";
    marker.map = mapView_;
    
    
    
    CLLocationManager *locMgr = self.locationManager;

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:startLongitude
                                                            longitude:startLatitude
                                                                 zoom:6]; // zoom can be modified if it's too deep or too shallow
    
    NSMutableArray *printers = self.printers;
    
    for (MPSPrinter *printer in printers)
    {
        double currLong = printer.longitude;
        double currLat = printer.latitude;
        
        NSString *currName = printer.building;
        NSString *currSnippet =  printer.room;
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(currLat, currLat);
        
        marker.title = currName;
        marker.snippet = currSnippet;
        marker.map = mapView_;
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    MPSPrinterViewController *detailController = segue.destinationViewController;
//    MPSPrinter *printer = ??????;
//    detailController.printer = printer;
//    detailController.title = [printer name];
}


@end
