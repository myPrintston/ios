//
//  MPSPrinterViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 4/3/14.
//
//

#import "MPSPrinterViewController.h"
#import "MPSErrorViewController.h"
#import "MPSPrinter.h"
#import "MPSMapAnnotation.h"

@interface MPSPrinterViewController ()

@end

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
    // Do any additional setup after loading the view.
    
    
    self.statusMsg.text = [NSString stringWithFormat:@"Status: %@", self.printer.statusMsg];
    
    
    // Make a map annotation for a pin from the printer and add it to the map view
    MPSMapAnnotation *mapPoint = [[MPSMapAnnotation alloc] init];
    mapPoint.coordinate = CLLocationCoordinate2DMake(self.printer.latitude, self.printer.longitude);
    [self.mapView addAnnotation:mapPoint];
    
    // Zoom to a region around the pin
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapPoint.coordinate, 500, 500);
    [self.mapView setRegion:region];
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

#pragma mark - MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *view = nil;
    static NSString *reuseIdentifier = @"MapAnnotation";
    
    // Return a MKPinAnnotationView with a simple accessory button
    view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if(!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        view.canShowCallout = YES;
        view.animatesDrop = YES;
    }
    
    return view;
}

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
