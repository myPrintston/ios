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
    
    NSString *urlstring = [@"http://54.186.188.121:2016/pids/" stringByAppendingString:[printerids componentsJoinedByString:@"/"]];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil)
        return;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (int i = 0; i < [printerids count]; i++)
    {
        MPSPrinter *printer = [self.printers objectAtIndex:i];
        printer.status    = [[jsonArray objectAtIndex:i][@"fields"][@"status"] integerValue];
        printer.statusMsg = [jsonArray objectAtIndex:i][@"fields"][@"statusMsg"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
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
    return [self.printers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"PrinterCell";
    
    MPSPrinter *currentPrinter = [self.printers objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = currentPrinter.building;
    
    if (currentPrinter.status == 0) cell.textLabel.textColor = [UIColor greenColor];
    if (currentPrinter.status == 1) cell.textLabel.textColor = [UIColor orangeColor];
    if (currentPrinter.status == 2) cell.textLabel.textColor = [UIColor redColor];
    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%dm) %@", (int)[currentPrinter dist], currentPrinter.room];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%dm) %@", (int)[currentPrinter distCL:self.locationManager.location], currentPrinter.room];
    
    //cell.imageView.contentMode = UIViewContentModeCenter;
    //cell.imageView.transform = CGAffineTransformMakeRotation([currentPrinter angle] + M_2_PI);
//    NSLog(@"%f", [currentPrinter angle]);
    
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
    detailController.title = [printer name];
}

@end
