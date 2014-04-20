//
//  MPSPrinter.m
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import "MPSPrinter.h"

static double userLongitude;
static double userLatitude;

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
        self.location  = [[CLLocation  alloc] initWithLatitude:self.latitude longitude:self.longitude];
        self.status    = [fields[@"status"] intValue];
        self.statusMsg = [fields objectForKey:@"statusMsg"];
    }
    
    return self;
}

- (void) dealloc {
}

+ (void) setUserLongitude:(double)newUserLongitude {
    userLongitude = newUserLongitude;
}

+ (void) setUserLatitude:(double)newUserLatitude {
    userLatitude = newUserLatitude;
}


// Calculate distance squared to a given position
- (double) dist2 {
    double dlong = 111200 * fabs((self.longitude - userLongitude));
    double dlat  = 101400 * fabs((self.latitude  - userLatitude));
    return dlong * dlong + dlat * dlat;
}

// Calculate distance to a given position
- (double) dist {
    return sqrt([self dist2]);
}

- (double) angle {
//    double dlong = 111200 * fabs((self.longitude - userLongitude));
//    double dlat  = 101400 * fabs((self.latitude  - userLatitude));
    
//    double dlong = (userLongitude - self.longitude) * M_PI / 180.0;
//    double dlat  = (userLatitude  - self.latitude)  * M_PI / 180.0;
    
    double fLng = userLongitude  * M_PI / 180.0;
    double fLat = userLatitude   * M_PI / 180.0;
    double tLng = self.longitude * M_PI / 180.0;
    double tLat = self.latitude  * M_PI / 180.0;
    
    return atan2(sin(fLng-tLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(fLng-tLng));
}

- (NSString*) name {
    return [NSString stringWithFormat:@"%@ - %@", self.building, self.room];
}

- (void) updateStatus {
    NSString *url_string = [NSString stringWithFormat:@"http://54.186.188.121:2016/?pid=%d", self.printerid];
    NSURL *url = [NSURL URLWithString:url_string];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data == nil)
        return;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    self.status    = [jsonArray[0][@"status"] integerValue];
    self.statusMsg = jsonArray[0][@"statusMsg"];
}

@end
