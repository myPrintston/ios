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
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%dm) %@", (int)[currentPrinter dist], currentPrinter.room];
    
    //cell.imageView.contentMode = UIViewContentModeCenter;
    //cell.imageView.transform = CGAffineTransformMakeRotation([currentPrinter angle] + M_2_PI);
    NSLog(@"%f", [currentPrinter angle]);
    
    return cell;
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
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
