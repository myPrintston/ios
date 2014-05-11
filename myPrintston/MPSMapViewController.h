//
//  MPSMapViewController.h
//  myPrintston
//
//  Created by Michael J Kim on 4/20/14.
//
//


#import <UIKit/UIKit.h>
#import <CoreLocation/Corelocation.h>
#import "MPSListViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MPSPrinterList.h"

@interface MPSMapViewController : UIViewController<GMSMapViewDelegate>

@property (nonatomic) MPSPrinterList *printerList;
@property (nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end
