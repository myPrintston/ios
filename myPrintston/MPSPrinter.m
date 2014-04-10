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
        //self.status    = [fields[@"status"] intValue];
        self.status = 1;
        self.statusMsg = [fields objectForKey:@"statusMsg"];
        
    }
    
    return self;
}

- (void) dealloc {
}


- (double) dist2:(double) userLongitude :(double)userLatitude {
    /*
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
    c = 2 * atan2( sqrt(a), sqrt(1-a) )
    d = R * c (where R is the radius of the Earth)
    */
    
    return (self.longitude - userLongitude) * (self.longitude - userLongitude) +
           (self.latitude  - userLatitude ) * (self.latitude  - userLatitude );
}

- (double) dist:(double)userLongitude :(double)userLatitude {
    return sqrt([self dist2: userLongitude :userLatitude]);
}

- (double) distance {
    return 3.1415926535;
}

- (NSString*) name {
    return [NSString stringWithFormat:@"%@ - %@", self.building, self.room];
}

@end
