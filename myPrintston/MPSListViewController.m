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

// Get some information from the MPSTabController and set the code for the pull down refresh.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MPSTabController *tabController = (MPSTabController *) self.tabBarController;
    self.printerList = tabController.printerList;
    self.locationManager = tabController.locationManager;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self
                action:@selector(updatePrinters:)
                forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

// Update the printer information every time we come to this view
- (void) viewWillAppear:(BOOL)animated {
    [self.printerList update];
    [self.printerList sort];
    [self.tableView reloadData];
}

// Method to call to update printers when pull down refresh is triggered
- (void) updatePrinters:(UIRefreshControl *)refresh
{
    [self.printerList update];
    [self.printerList sort];
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
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

// Return the number of sections. In this case we only have 1.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the number of rows in the section. In this case it's the number of printers.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.printerList count];
}

// Configure each cell. We give it a title, subtitle, and color based on the printer
//   and its status.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPSPrinter *currentPrinter = [self.printerList.printers objectAtIndex:indexPath.row];
      
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrinterCell" forIndexPath:indexPath];
    
    // Title and subtitle
    cell.textLabel.text = currentPrinter.building;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%dm) %@", (int)[currentPrinter distCL:self.locationManager.location], currentPrinter.room];
    
    // Configure the color
    if (currentPrinter.status == 0)
        cell.textLabel.textColor = [UIColor colorWithRed:0/255.0f green:134/255.0f blue:37/255.0f alpha:1.0f];
    else if (currentPrinter.status == 1)
        cell.textLabel.textColor = [UIColor colorWithRed:231/255.0f green:162/255.0f blue:76/255.0f alpha:1.0f];
    else if (currentPrinter.status == 2)
        cell.textLabel.textColor = [UIColor colorWithRed:231/255.0f green:56/255.0f blue:28/255.0f alpha:1.0f];
    
    
    return cell;
}


#pragma mark - Navigation

// Pass on information to MPSPrinterViewController before we segue to it.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MPSPrinterViewController *detailController = segue.destinationViewController;
    MPSPrinter *printer = [self.printerList.printers objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailController.printer = printer;
    detailController.locationManager = self.locationManager;
    detailController.title = [printer name];
}

@end
