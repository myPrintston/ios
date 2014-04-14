//
//  MPSMapAnnotation.h
//  myPrintston
//
//  Created by Michael J Kim on 4/13/14.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MPSPrinter.h"

@interface MPSMapAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id) initWithPrinter:(MPSPrinter*)printer;

@end
