//
//  MPSMapAnnotation.m
//  myPrintston
//
//  Created by Michael J Kim on 4/13/14.
//
//

#import "MPSMapAnnotation.h"

@implementation MPSMapAnnotation

- (id) initWithPrinter:(MPSPrinter*)printer
{
    self.coordinate = CLLocationCoordinate2DMake(printer.latitude, printer.longitude);
    return self;
}


@end
