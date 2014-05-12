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

- (void) viewWillAppear:(BOOL)animated {
    [self.printerList update];
    [self.printerList sort];
    [self.tableView reloadData];
}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.printerList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"PrinterCell";
    
    MPSPrinter *currentPrinter = [self.printerList.printers objectAtIndex:indexPath.row];
      
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
    MPSPrinter *printer = [self.printerList.printers objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailController.printer = printer;
    detailController.locationManager = self.locationManager;
    detailController.title = [printer name];
}

@end
