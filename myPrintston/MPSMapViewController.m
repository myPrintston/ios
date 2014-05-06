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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//if (currentPrinter.status == 0) cell.textLabel.textColor = [UIColor greenColor];
//if (currentPrinter.status == 1) cell.textLabel.textColor = [UIColor orangeColor];
//if (currentPrinter.status == 2) cell.textLabel.textColor = [UIColor redColor];

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLLocationManager *locMgr = self.locationManager;
    double posLat = locMgr.location.coordinate.latitude;
    double posLong = locMgr.location.coordinate.longitude;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:posLat
                                                            longitude:posLong
                                                                 zoom:18];
    

    //testing coords: 40.343658, -74.658338

//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.343658
//                                                            longitude:-74.658338
//                                                              zoom:18];
    
    
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
    
    NSMutableArray *printers = self.printers;
    
    for (MPSPrinter *printer in printers)
    {
        double currLong = printer.longitude;
        double currLat = printer.latitude;
        
        NSLog(@"%f, %f", currLat, currLong);
        
        double currStatus = printer.status;
        
        
        
        NSString *currName = printer.building;
        NSString *currSnippet =  printer.room;
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(currLat, currLong);
        
        if (currStatus == 0)
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
        }
        else if (currStatus == 1)
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
        }
        else
        {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        }
        
        marker.title = currName;
        marker.snippet = currSnippet;
        marker.map = self.mapView;
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
