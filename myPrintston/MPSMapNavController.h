//
//  MPSMapNavController.h
//  myPrintston
//
//  Created by Michael J Kim on 4/20/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/Corelocation.h>

@interface MPSMapNavController : UINavigationController

@property (nonatomic) NSMutableArray *printers;
@property (nonatomic) CLLocationManager *locationManager;

@end
