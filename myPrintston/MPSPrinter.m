//
//  MPSPrinter.m
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import "MPSPrinter.h"

int printer_count = 0;

@implementation MPSPrinter

+ (int) count {return printer_count;}

- (id) init {
    printer_count++;
    return self;
}

- (void) dealloc {
    printer_count--;
}

// Getter Functions
- (int) printerid {
    return printerid;
}

- (double) longitude {
    return longitude;
}
- (double) latitude {
    return latitude;
}

// Setter Functions
- (void) setPrinterId: (int) new_printerid {
    self->printerid = new_printerid;
}

- (void) setLongitude:(double)new_longitude {
    self->longitude = new_longitude;
}

- (void) setLatitude:(double)new_latitude {
    self->latitude = new_latitude;
}

@end
