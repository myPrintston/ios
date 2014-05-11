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

- (IBAction)submit:(UIBarButtonItem *)sender {
    UIAlertView *alert;
    
    NSMutableArray *errorids = [[NSMutableArray alloc] init];
    for (int i = 0; i < [possibleErrors count]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
            [errorids addObject:[NSNumber numberWithInt:[self->possibleErrors[i] errorid]]];
    }
    
    if ([errorids count] == 0) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Submit Failure"
                 message:@"Please select at least one error"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/fixerrors/%d/%@", IP, self.printer.printerid, [errorids componentsJoinedByString:@"/"]];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (!data) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Could not connect to the server"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (![jsonArray[0] boolValue]) {
        alert = [[UIAlertView alloc]
                initWithTitle:@"Submit Failure"
                message:@"Server Error"
                delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
    }
    
    alert = [[UIAlertView alloc]
             initWithTitle:@"Fixed"
             message:jsonArray[1]
             delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
    [alert show];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
