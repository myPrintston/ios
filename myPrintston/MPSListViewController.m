//
//  MPSListViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import "MPSListViewController.h"
#import "MPSPrinterViewController.h"
#import "MPSPrinter.h"
#import <CoreLocation/Corelocation.h>
#import "Reachability.h"

@interface MPSListViewController() {
    NSMutableArray *printers;
    CLLocationManager *locationManager;
}
@end

@implementation MPSListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    locationManager = [[CLLocationManager alloc] init];

    self->printers = self.loadPrinters;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didMoveToParentViewController:(UIViewController *)parent{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self->printers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"PrinterCell";
    
    MPSPrinter *currentPrinter = [self->printers objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = currentPrinter.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", [currentPrinter distance]];
    
    return cell;
}


- (NSMutableArray*) loadPrinters
{
    /*
    NSURL *url = [NSURL URLWithString:@"http://54.186.188.121:2016/333"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"ret=%@", ret); */
    
    if ([self canConnect])
        NSLog(@"HIHIHI");
    
    NSURL *url = [NSURL URLWithString:@"http://54.186.188.121:2016/?fromios"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"%@", jsonArray[0]);
    
    /*
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (connectionError == nil)
         {
             
             NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
             NSLog(@"ret=%@", result);
         } else {
             NSLog(@"connection error");
             NSLog(@"%@", [NSString stringWithFormat:@"%d", [connectionError code]]);
             NSLog(@"Error : %@", [connectionError localizedDescription]);
             NSLog(@"Error : %@", [connectionError localizedRecoveryOptions]);
             NSLog(@"Error : %@", [connectionError localizedRecoverySuggestion]);
             NSLog(@"Error : %@", [connectionError localizedFailureReason]);
         }
     }]; */
    
    
    MPSPrinter *printer1 = [[MPSPrinter alloc] initWithName:@"Witherspoon"];
    printer1.status = YES;
    MPSPrinter *printer2 = [[MPSPrinter alloc] initWithName:@"Icahn"];
    printer2.status = NO;
    MPSPrinter *printer3 = [[MPSPrinter alloc] initWithName:@"McCarter"];
    printer3.status = NO;
    MPSPrinter *printer4 = [[MPSPrinter alloc] initWithName:@"Witherspoon"];
    printer4.status = YES;
    MPSPrinter *printer5 = [[MPSPrinter alloc] initWithName:@"Icahn"];
    printer5.status = NO;
    MPSPrinter *printer6 = [[MPSPrinter alloc] initWithName:@"McCarter"];
    printer6.status = YES;
    MPSPrinter *printer7 = [[MPSPrinter alloc] initWithName:@"Witherspoon"];
    printer7.status = YES;
    MPSPrinter *printer8 = [[MPSPrinter alloc] initWithName:@"Icahn"];
    printer8.status = NO;
    MPSPrinter *printer9 = [[MPSPrinter alloc] initWithName:@"McCarter"];
    printer9.status = YES;
    MPSPrinter *printer10 = [[MPSPrinter alloc] initWithName:@"1901"];
    printer10.status = YES;
    
    return [NSMutableArray arrayWithObjects:printer1,printer2,printer3,printer4,printer5,printer6,printer7,printer8,printer9,printer10, nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (BOOL)canConnect {
    Reachability *r = [Reachability reachabilityWithHostName:@"http://54.186.188.121:2016/?json"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if (internetStatus == NotReachable) {
        NSLog(@"Not Reachable");
    }
    if (internetStatus == ReachableViaWiFi) {
        NSLog(@"Reachable Via Wifi");
    }
    if (internetStatus == ReachableViaWWAN) {
        NSLog(@"Reachable Via WWAN");
    }
    if ((internetStatus == ReachableViaWiFi) || (internetStatus == ReachableViaWWAN)) {
        NSLog(@"Reachable");
    }
    
    return ((internetStatus == ReachableViaWiFi) || (internetStatus == ReachableViaWWAN));
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
// Modify the prepareForSegue method by
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MPSPrinterViewController *detailController =segue.destinationViewController;
    MPSPrinter *printer = [self->printers objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailController.printer = printer;
    detailController.title = printer.name;
}

@end
