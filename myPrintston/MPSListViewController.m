//
//  MPSListViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 3/28/14.
//
//

#import "MPSListViewController.h"
#import "MPSPrinterViewController.h"
#import "MPSTabController.h"
#import "MPSListNavController.h"
#import "MPSPrinter.h"

extern NSString *IP;

@interface MPSListViewController()

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

- (void) viewWillAppear:(BOOL)animated {
    NSMutableArray *printerids = [[NSMutableArray alloc] init];
    for (MPSPrinter *printer in self.printers)
        [printerids addObject:[NSNumber numberWithInt:printer.printerid]];
    
    NSString *urlstring = [[NSString stringWithFormat:@"%@/pids/", IP] stringByAppendingString:[printerids componentsJoinedByString:@"/"]];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil)
        return;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([jsonArray count] == 0) {
        self.printers = [self loadPrinters];
        [self.tableView reloadData];
    } else {
        for (int i = 0; i < [printerids count]; i++)
        {
            MPSPrinter *printer = [self.printers objectAtIndex:i];
            printer.status    = [[jsonArray objectAtIndex:i][@"fields"][@"status"] intValue];
            printer.statusMsg = [jsonArray objectAtIndex:i][@"fields"][@"statusMsg"];
        }
    }
    
    [self sortPrinters];
}

- (void) updatePrinters:(UIRefreshControl *)refresh
{
    [self.tableView reloadData];
    NSMutableArray *printerids = [[NSMutableArray alloc] init];
    for (MPSPrinter *printer in self.printers)
        [printerids addObject:[NSNumber numberWithInt:printer.printerid]];
    
    NSString *urlstring = [[NSString stringWithFormat:@"%@/pids/", IP] stringByAppendingString:[printerids componentsJoinedByString:@"/"]];

    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil)
        return;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([jsonArray count] == 0) {
        self.printers = [self loadPrinters];
        [self.tableView reloadData];
    } else {
        for (int i = 0; i < [printerids count]; i++)
        {
            MPSPrinter *printer = [self.printers objectAtIndex:i];
            printer.status    = [[jsonArray objectAtIndex:i][@"fields"][@"status"] intValue];
            printer.statusMsg = [jsonArray objectAtIndex:i][@"fields"][@"statusMsg"];
        }
    }

    [self sortPrinters];
    
//    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void) sortPrinters
{
    CLLocation *userLocation = self.locationManager.location;
    [self.printers sortUsingComparator:^(id p1, id p2) {
        if ([p1 distCL:userLocation] > [p2 distCL:userLocation])
            return (NSComparisonResult) NSOrderedDescending;
        else
            return (NSComparisonResult) NSOrderedAscending;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self
                action:@selector(updatePrinters:)
                forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray*) loadPrinters
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pall/", IP]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data == nil)
        return [NSMutableArray arrayWithObjects: nil];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray *urlprinters = [[NSMutableArray alloc] init];
    for (NSDictionary *printerInfo in jsonArray) {
        MPSPrinter *printer = [[MPSPrinter alloc] initWithDictionary:printerInfo];
        [urlprinters addObject:printer];
    }
    
    return urlprinters;
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
    return [self.printers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"PrinterCell";
    
    MPSPrinter *currentPrinter = [self.printers objectAtIndex:indexPath.row];
      
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = currentPrinter.building;
    
    if (currentPrinter.status == 0) cell.textLabel.textColor = [UIColor colorWithRed:0/255.0f green:134/255.0f blue:37/255.0f alpha:1.0f];
    if (currentPrinter.status == 1) cell.textLabel.textColor = [UIColor colorWithRed:231/255.0f green:162/255.0f blue:76/255.0f alpha:1.0f];
    if (currentPrinter.status == 2) cell.textLabel.textColor = [UIColor colorWithRed:231/255.0f green:56/255.0f blue:28/255.0f alpha:1.0f];
    
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%dm) %@", (int)[currentPrinter distCL:self.locationManager.location], currentPrinter.room];
    
    return cell;
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
// Modify the prepareForSegue method by
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MPSPrinterViewController *detailController = segue.destinationViewController;
    MPSPrinter *printer = [self.printers objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailController.printer = printer;
    detailController.locationManager = self.locationManager;
    detailController.title = [printer name];
}

@end
