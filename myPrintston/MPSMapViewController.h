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

@interface MPSMapViewController : UIViewController<GMSMapViewDelegate>

@property (nonatomic) NSMutableArray *printers;
@property (nonatomic) CLLocationManager *locationManager;

@end
