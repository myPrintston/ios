//
//  MPSPrinterViewController.h
//  myPrintston
//
//  Created by Michael J Kim on 4/3/14.
//
//

#import <UIKit/UIKit.h>
#import "MPSPrinter.h"
#import <MapKit/MapKit.h>

@interface MPSPrinterViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic) MPSPrinter *printer;
@property (weak, nonatomic) IBOutlet UIButton *errorButton;
@property (weak, nonatomic) IBOutlet UILabel *statusMsg;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
