//
//  MPSPrinter.m
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import "MPSPrinter.h"

@implementation MPSPrinter

- (id) init {
    return self;
}

- (id)initWithName:(NSString *)new_name
{
    self = [super init];
    
    if (self)
    {
        name = new_name;
    }
    
    return self;
}

- (void) dealloc {
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

- (NSString*) name {
    return name;
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

- (void) setName:(NSString*)new_name{
    self->name = new_name;
}

@end
