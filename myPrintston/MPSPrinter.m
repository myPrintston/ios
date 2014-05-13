//
//  MPSPrinter.m
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import "MPSPrinter.h"

extern NSString* IP;

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

// Initialize a Printer object with a JSON entry provided from the server
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


// Calculates the distance from the printer to the user
- (double) distCL:(CLLocation*)userLocation {
    return [self.location distanceFromLocation:userLocation];
}


// Form the name of a printer based on the buildling name and room number
- (NSString*) name {
    return [NSString stringWithFormat:@"%@ - %@", self.building, self.room];
}

// Update the status of the printer by querying the server
- (void) updateStatus {
    NSString *url_string = [NSString stringWithFormat:@"%@/pid/%d/", IP, self.printerid];
    NSURL *url = [NSURL URLWithString:url_string];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data == nil)
        return;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    self.status    = [jsonArray[0][@"status"] intValue];
    self.statusMsg = jsonArray[0][@"statusMsg"];
}

@end
