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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    double posLat  = self.locationManager.location.coordinate.latitude;
//    double posLong = self.locationManager.location.coordinate.longitude;
//    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:posLat
//                                                            longitude:posLong
//                                                                 zoom:18];
//
//    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:camera];
//    [self.mapView moveCamera:update];
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [self updatePrinters];
    [self.mapView clear];
    
    double posLat = self.locationManager.location.coordinate.latitude;
    double posLong = self.locationManager.location.coordinate.longitude;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:posLat
                                                            longitude:posLong
                                                                 zoom:17];

    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:camera];
    [self.mapView moveCamera:update];
    
    for (MPSPrinter *printer in self.printers)
    {
        double currLong = printer.longitude;
        double currLat = printer.latitude;
        
        NSString *currName = printer.building;
        NSString *currSnippet =  printer.room;
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(currLat, currLong);
        
        if (printer.status == 0)
            marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
        else if (printer.status == 1)
            marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
        else
            marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        
        marker.title = currName;
        marker.snippet = currSnippet;
        marker.map = self.mapView;
        marker.userData = printer;
    }
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

- (void) updatePrinters {
    NSMutableArray *printerids = [[NSMutableArray alloc] init];
    for (MPSPrinter *printer in self.printers)
        [printerids addObject:[NSNumber numberWithInt:printer.printerid]];
    
    NSString *urlstring = [[NSString stringWithFormat:@"%@/pids/", IP] stringByAppendingString:[printerids componentsJoinedByString:@"/"]];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil)
        return;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([jsonArray count] == 0) {
        self.printers = [self loadPrinters];
    } else {
        for (int i = 0; i < [printerids count]; i++)
        {
            MPSPrinter *printer = [self.printers objectAtIndex:i];
            printer.status    = [[jsonArray objectAtIndex:i][@"fields"][@"status"] intValue];
            printer.statusMsg = [jsonArray objectAtIndex:i][@"fields"][@"statusMsg"];
        }
    }
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
    detailController.locationManager = self.locationManager;
    detailController.title = [printer name];
}


@end
