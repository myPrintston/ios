//
//  MPSFixErrorController.m
//  myPrintston
//
//  Created by Michael J Kim on 5/7/14.
//
//

#import "MPSFixErrorController.h"
#import "MPSErrorType.h"

extern NSString *IP;

@interface MPSFixErrorController () {
    NSMutableArray *possibleErrors;
}

@end

@implementation MPSFixErrorController

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
    
    possibleErrors = [self loadPossibleErrors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Query server and get the error types
- (NSMutableArray*) loadPossibleErrors
{
    NSString *urlString = [NSString stringWithFormat:@"%@/geterrors/%d", IP, self.printer.printerid];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSLog(@"%@", urlString);
    NSLog(@"%@", url);
    NSLog(@"%@", data);
    
    if (!data) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Could not connect to the server"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return [[NSMutableArray alloc] init];
    }
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"HI");
    NSLog(@"%@", jsonArray);
    
    NSMutableArray *urlerrors = [[NSMutableArray alloc] init];
    MPSErrorType *other;
    
    for (NSDictionary *errorInfo in jsonArray) {
        MPSErrorType *error = [[MPSErrorType alloc] initWithDictionary:errorInfo];
        
        if ([errorInfo[@"fields"][@"eMsg"] isEqualToString:@"Other"])
            other = error;
        else
            [urlerrors addObject:error];
    }
    
    if (other)
        [urlerrors addObject:other];
    
    return urlerrors;
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
    return [possibleErrors count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"Error";
    
    MPSErrorType *currentError = [self->possibleErrors objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = currentError.eMsg;
    
    return cell;
}

- (void)tableView:(UITableView *)errorList didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [errorList cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    [errorList deselectRowAtIndexPath:indexPath animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submit:(UIBarButtonItem *)sender {
}
@end
