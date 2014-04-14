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
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    NSDictionary *fields = [dictionary objectForKey:@"fields"];
    
    if(self = [self init]) {
        // Assign all properties with keyed values from the dictionary
        self.printerid = [dictionary[@"pk"] intValue];
        self.building  = [fields objectForKey:@"buildingName"];
        self.room      = [fields objectForKey:@"roomNumber"];
        self.longitude = [fields[@"longitude"] doubleValue];
        self.latitude  = [fields[@"latitude"]  doubleValue];
        self.status    = [fields[@"status"] intValue];
        self.statusMsg = [fields objectForKey:@"statusMsg"];
    }
    
    return self;
}

- (void) dealloc {
}

// Calculate distance squared to a given position
- (double) dist2:(double) userLongitude :(double)userLatitude {
    
    double dlong = 111200 * fabs((self.longitude - userLongitude));
    double dlat  = 101400 * fabs((self.latitude  - userLatitude));
    
    return dlong * dlong + dlat * dlat;
}

// Calculate distance to a given position
- (double) dist:(double)userLongitude :(double)userLatitude {
    return sqrt([self dist2:userLongitude :userLatitude]);
}

- (double) distance {
    return 3.1415926535;
}

- (NSString*) name {
    return [NSString stringWithFormat:@"%@ - %@", self.building, self.room];
}

@end
